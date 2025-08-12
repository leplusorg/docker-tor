const Configuration = {
  /*
   * Inherit rules from conventional commits.
   */
  extends: ["@commitlint/config-conventional"],

  /*
   * Any rules defined here will override rules from parent.
   */
  rules: {
    "header-max-length": [1, "always", 100],
    "body-max-line-length": [1, "always", 100],
    "footer-max-length": [1, "always", 100],
  },
};

export default Configuration;
