const USERNAME_REGEX = /### Core Author username\n+(.+)/;
const SNIPPET_REGEX =
  /### Core \.yml snippet\s+(?:```yml\n)?([\s\S]*?)(?:\s*```)?\s*$/;

module.exports = ({ github, context, core }) => {
  const yaml = require("js-yaml");
  const fs = require("fs");
  const body = context.payload.issue.body;

  const usernameMatch = body.match(USERNAME_REGEX);
  const snippetMatch = body.match(SNIPPET_REGEX);

  if (usernameMatch && snippetMatch) {
    const username = usernameMatch[1].trim().replace("@", "");

    core.setOutput("username", username);

    const snippet = snippetMatch[1]
      .replace("```yml", "")
      .replace("```", "")
      .trim()
      .split("\n")
      .map((l) => l.trim())
      .join("\n");

    let yamlSnippet = null;

    try {
      yamlSnippet = yaml.load(snippet);
    } catch (err) {
      github.rest.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: `Error processing the yaml snippet, sorry`,
      });

      console.log(err);

      core.setOutput("close-issue", false);
      return {};
    }

    const reposFile = yaml.load(
      fs.readFileSync("_data/repositories.yml", "utf8")
    );

    const knownAuthor = reposFile
      .map(({ username }) => username)
      .includes(username);

    core.setOutput("known-author", knownAuthor);

    if (!knownAuthor) {
      github.rest.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: `Thanks for the submission!
        Looks like \`${username}\` doesn't have any cores in the inventory yet.
        So the PR'll require manual approval`,
      });
    }

    const currentCores = knownAuthor
      ? reposFile.find(({ username: u }) => u === username).cores
      : [];

    const existsAlready = Boolean(
      currentCores.find(
        // Can probably improve this comparison
        (c) => JSON.stringify(c) === JSON.stringify(yamlSnippet)
      )
    );

    core.setOutput("exists-already", existsAlready);

    if (existsAlready) {
      github.rest.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: `Thanks for the submission!
        Looks like that core is in the inventory already`,
      });

      core.setOutput("close-issue", true);

      return { username, knownAuthor, existsAlready };
    }

    const newReposFile = [
      ...reposFile.filter(({ username: u }) => u !== username),
      { username, cores: [...currentCores, yamlSnippet] },
    ];

    newReposFile.sort((a, b) => a.username.localeCompare(b.username));

    fs.writeFileSync(
      "_data/repositories.yml",
      yaml.dump(newReposFile, { noRefs: true })
    );
    core.setOutput("close-issue", false);
    return { username, knownAuthor, existsAlready };
  }

  console.log("\n---\n");

  console.error(body);

  console.log("\n---\n");

  console.error(
    `Username Regex: ${usernameMatch}, Snippet Regex: ${snippetMatch}`
  );

  return {};
};
