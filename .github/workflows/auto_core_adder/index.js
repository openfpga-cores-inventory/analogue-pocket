const OWNER_PATTERN = /### GitHub Username\s+@?(?<owner>[\w-]{1,39})/;
const REPOSITORY_PATTERN = /### Repository Name\s+(?<repository>[\w\.-]+)/;
const PRERELEASE_PATTERN = /### Pre-release\s+-\s+\[(?<prerelease>[\sxX])\]/;
const FILTER_PATTERN = /### Asset Filter\s+(?<filter>.+)/;
const PATH_PATTERN = /### Path\s+(?<path>.+)/;

const NO_RESPONSE = '_No response_';
const SOURCES_PATH = '_data/sources.yml';

module.exports = ({ github, context, core }) => {
  const yaml = require("js-yaml");
  const fs = require("fs");
  const body = context.payload.issue.body;

  const ownerMatch = OWNER_PATTERN.exec(body);
  const repositoryMatch = REPOSITORY_PATTERN.exec(body);

  if (!ownerMatch || !repositoryMatch) {
    console.error(`Failed to match owner or repository: ${body}`);

    return {};
  }

  const prereleaseMatch = PRERELEASE_PATTERN.exec(body);
  const filterMatch = FILTER_PATTERN.exec(body);
  const pathMatch = PATH_PATTERN.exec(body);

  const { owner } = ownerMatch.groups;
  const { repository } = repositoryMatch.groups;
  const { prerelease } = prereleaseMatch.groups;
  const { filter } = filterMatch.groups;
  const { path } = pathMatch.groups;

  core.setOutput("username", owner);

  const sources = yaml.load(
    fs.readFileSync(SOURCES_PATH, "utf8")
  );

  const ownerSources = sources.find(
    (source) => source.owner === owner
  );

  const ownerExists = !!ownerSources;
  core.setOutput("known-author", ownerExists);

  if (!ownerExists) {
    github.rest.issues.createComment({
      issue_number: context.issue.number,
      owner: context.repo.owner,
      repo: context.repo.repo,
      body: `Thanks for the submission!
      Looks like \`${owner}\` doesn't have any cores in the inventory yet.
      So the PR'll require manual approval`,
    });
  }

  const ownerRepositories = ownerSources.repositories.filter(
    (ownerRepository) => ownerRepository.name === repository
  );

  const existingSource = ownerRepositories.find(
    (ownerRepository) =>
      (path === NO_RESPONSE || ownerRepository.path === path) ||
      (!!ownerRepository.prerelease === (/[xX]/.test(prerelease)) && (filter === NO_RESPONSE || ownerRepository.filter === filter))      
  );

  const sourceExists = !!existingSource;
  core.setOutput("exists-already", sourceExists);

  if (sourceExists) {
    github.rest.issues.createComment({
      issue_number: context.issue.number,
      owner: context.repo.owner,
      repo: context.repo.repo,
      body: `Thanks for the submission!
      Looks like that core is in the inventory already`,
    });

    core.setOutput("close-issue", true);

    return { owner, ownerExists, sourceExists };
  }

  const source = {
    name: repository
  };

  if (/[xX]/.test(prerelease)) source.prerelease = true;
  if (filter !== NO_RESPONSE) source.filter = filter;
  if (path !== NO_RESPONSE) source.path = path;

  ownerSources.repositories.push(source);

  fs.writeFileSync(SOURCES_PATH,
    yaml.dump(sources, { noRefs: true })
  );

  core.setOutput("close-issue", false);

  return { owner, ownerExists, sourceExists };
};
