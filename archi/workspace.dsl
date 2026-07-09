workspace "DnD" "" {
	!identifiers hierarchical
	!impliedRelationships false
	
	model {
		dnd = softwareSystem "DnD" "A role-playing game where players embark on adventures in a fantasy world" "#dnd" {
			group "destiny" {
				dice_roller = container "The Dice Roller" "Determines outcomes of actions" "Strands Agents" "#agent, #strands, #dice"
			}
			
			group "wisdom" {
				sacred_chamber = container "The Sacred Chamber" "Enchanted repository containing all the wisdom of the realms" "SQLite" "#file, #chamber"
				sage_of_rules = container "The Sage of Rules" "Guards D&D lore & mechanics" "Strands Agents" "#agent, #strands, #sage" {
					-> sacred_chamber "consults" "" ""
				}
			}
			
			group "adventure" {
				hall_of_heroes = container "The Hall of Heroes" "Because heroes deserve to be remembered" "JSON" "#file, #hall"
				character_chronicler = container "The Chronicler" "A master of heroic tales and legendary statistics" "Strands Agents" "#agent, #strands, #chronicler" {
					-> hall_of_heroes "records in" "" ""
				}
			}
			
			game_master = container "The Orchestrator" "Coordinates all adventures" "Strands Agents" "#agent, #strands, #master" {
				-> dice_roller "tempts fate" "mcp" ""
				-> sage_of_rules "queries for ancient rule wisdom" "a2a" ""
				-> character_chronicler "tracks heroic destinies" "a2a" ""
			}
		}
		
		player = person "The Heroe" "An innocent traveler on a quest for glory" "" {
			-> dnd "wanders" "" ""
			-> dnd.game_master "obeys" "" ""
		}
		
		local_ = deploymentEnvironment "local" {
			deploymentNode "Local Machine" "" "Windows 11" "#windows" {
				deploymentNode "orchestration" "" "Aspire" "#aspire" {
					deploymentNode "game_master" "" "FastApi" "#fastapi" {
						containerInstance dnd.game_master "" "#strands"
					}
					deploymentNode "character_chronicler" "" "A2AServer" "#strands" {
						containerInstance dnd.character_chronicler "" "#strands"
					}
					deploymentNode "sage_of_rules" "" "A2AServer" "#strands" {
						containerInstance dnd.sage_of_rules "" "#strands"
					}
					deploymentNode "dice_roller" "" "FastMCP" "#strands" {
						containerInstance dnd.dice_roller "" "#strands"
					}
				}
			}
		}
	}
	
	views {
		theme https://raw.githubusercontent.com/rvr06/cornifer-contrib/main/themes/topology/theme.json
		theme https://raw.githubusercontent.com/rvr06/cornifer-contrib/main/themes/heraldry2/theme.json
		
		properties {
			"structurizr.sort" "created"
		}
		
		styles {
			element Person {
				stroke #834187
			}
			element #agent {
				shape robot
			}
			element #strands {
				stroke #00ff77
				icon strands.svg
			}
			element #dnd {
				stroke #ED1C24
				icon dnd.svg
			}
			element #hall {
				stroke #ff1493
				icon json.svg
			}
			element #chamber {
				stroke #003B57
				icon sqlite.svg
			}
		}
		
		systemLandscape "C4_L" {
			include *
		}
		
		container dnd "C4_2" {
			include *
		}
		
		deployment * local_ "C4_D" {
			include *
		}
	}
}
