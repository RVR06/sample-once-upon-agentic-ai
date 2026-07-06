#:package Aspire.Hosting.Python@13.4.6
#:sdk Aspire.AppHost.Sdk@13.4.6

using Aspire.Hosting;

var builder = DistributedApplication.CreateBuilder(args);

var region = builder.AddParameter("aws-default-region", secret: true);
var accessKeyId = builder.AddParameter("aws-access-key-id", secret: true);
var secretAccessKey = builder.AddParameter("aws-secret-access-key", secret: true);
var sessionToken = builder.AddParameter("aws-session-token", secret: true);

var dice_roller = builder.AddPythonApp("dice-roll-mcp", "../4_mcp_integration/", "dice_roll_mcp_server.py")
    .WithVirtualEnvironment("../.venv")
    // .WithUv()
    .WithEnvironment("AWS_DEFAULT_REGION", region)
    .WithEnvironment("AWS_ACCESS_KEY_ID", accessKeyId)
    .WithEnvironment("AWS_SECRET_ACCESS_KEY", secretAccessKey)
    .WithEnvironment("AWS_SESSION_TOKEN", sessionToken);

var character_agent = builder.AddPythonApp("character-agent", "../5_a2a_integration/agents/character_agent/", "character_agent.py")
    .WithVirtualEnvironment("../../../.venv")
    // .WithUv()
    .WithEnvironment("AWS_DEFAULT_REGION", region)
    .WithEnvironment("AWS_ACCESS_KEY_ID", accessKeyId)
    .WithEnvironment("AWS_SECRET_ACCESS_KEY", secretAccessKey)
    .WithEnvironment("AWS_SESSION_TOKEN", sessionToken);

var rules_agent = builder.AddPythonApp("rules-agent", "../5_a2a_integration/agents/rules_agent/", "rules_agent.py")
    .WithVirtualEnvironment("../../../.venv")
    // .WithUv()
    .WithEnvironment("AWS_DEFAULT_REGION", region)
    .WithEnvironment("AWS_ACCESS_KEY_ID", accessKeyId)
    .WithEnvironment("AWS_SECRET_ACCESS_KEY", secretAccessKey)
    .WithEnvironment("AWS_SESSION_TOKEN", sessionToken);

builder.AddPythonApp("gamemaster-orchestrator", "../5_a2a_integration/agents/gamemaster_orchestrator/", "gamemaster_orchestrator.py")
    .WithVirtualEnvironment("../../../.venv")
    // .WithUv()
    .WithReference(dice_roller)
    .WithReference(character_agent)
    .WithReference(rules_agent)
    .WithEnvironment("AWS_DEFAULT_REGION", region)
    .WithEnvironment("AWS_ACCESS_KEY_ID", accessKeyId)
    .WithEnvironment("AWS_SECRET_ACCESS_KEY", secretAccessKey)
    .WithEnvironment("AWS_SESSION_TOKEN", sessionToken);

builder.AddExternalService("character-ui", "https://aws-samples.github.io/sample-once-upon-agentic-ai/");

builder.Build().Run();