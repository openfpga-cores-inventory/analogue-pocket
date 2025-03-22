const REPOSITORY_PATTERN = /### GitHub Repository\s+(?<repository>[\w-]{1,39}\/[\w\.-]+)/;
const FILTER_PATTERN = /### Asset Filter\s+(?<filter>.+)/;
const PATH_PATTERN = /### Path\s+(?<path>.+)/;

const NO_RESPONSE = '_No response_';
const SOURCES_PATH = '_data/sources.yml';

module.exports = ({ github, context, core }) => {
  const yaml = require("js-yaml");
  const fs = require("fs");
  const body = context.payload.issue.body;

  if (!REPOSITORY_PATTERN.test(body)) {
    console.error(`Failed to match repository: ${body}`);
    return {};
  }

  const { repository } = REPOSITORY_PATTERN.exec(body).groups;

  const sources = yaml.load(
    fs.readFileSync(SOURCES_PATH, "utf8")
  );

  const source = sources.find(
    (source) => source.repository === repository.toLowerCase()
  );

  // Add the source if it doesn't exist
  if (!source) {
    const source = {
      repository: repository.toLowerCase()
    };

    if (filter !== NO_RESPONSE) source.assets = [filter];
    if (path !== NO_RESPONSE) source.contents = [path];

    sources.push(source);

    fs.writeFileSync(SOURCES_PATH,
      yaml.dump(sources, { noRefs: true })
    );

    core.setOutput("close-issue", false);
    return { exists: false };
  }

  const { filter } = FILTER_PATTERN.exec(body).groups;
  const { path } = PATH_PATTERN.exec(body).groups;

  const exists = (
    (filter !== NO_RESPONSE && source.assets?.includes(filter)) ||
    (path !== NO_RESPONSE && source.contents?.includes(path)) ||
    !source.assets && !source.contents
  );

  if (exists) {
    github.rest.issues.createComment({
      issue_number: context.issue.number,
      owner: context.repo.owner,
      repo: context.repo.repo,
      body: "Thank you for your submission! Looks like the core is already being tracked."
    });

    core.setOutput("close-issue", true);
    return { exists: true };
  }

  if (filter !== NO_RESPONSE) (source.assets ||= []).push(filter);
  if (path !== NO_RESPONSE) (source.contents ||= []).push(path);

  fs.writeFileSync(SOURCES_PATH,
    yaml.dump(sources, { noRefs: true })
  );

  core.setOutput("close-issue", false);
  return { exists: false };
};
