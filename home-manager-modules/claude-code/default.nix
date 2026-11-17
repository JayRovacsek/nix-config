{ self, ... }:
{
  imports = with self.homeManagerModules; [
    agent-context
    agent-permissions
    agents
    skills
  ];

  programs.claude-code = {
    enable = true;
    enableAgentIntegration = true;
    enableContextIntegration = true;
    enablePermissionIntegration = true;
    enableSkillIntegration = true;
  };
}
