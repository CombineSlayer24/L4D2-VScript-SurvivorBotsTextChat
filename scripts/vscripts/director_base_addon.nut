Msg( "-----------------------------------\n" );
Msg( "  Bot Text Chat Script Initialized\n"  );
Msg( "-----------------------------------\n" );

// TODO:
// --------------------------------------------------------------------------
// Chat when they die
// Chat when they are low on health (Begging to be healed)
// Chat when they are on 3rd strike
// Chat when under attack by an SI
// --------------------------------------------------------------------------
// Credit to Trash Talking Special AI for inspiration.

BotTextChatter <-
{
	// Return all SurvivorBots
	function GetAllSurvivorBots()
	{
		local SurvivorBots = []
		local Bot = null

		// Search for all bots
		while ( Bot = Entities.FindByClassname( Bot, "player" ) )
			if ( Bot.IsSurvivor() && IsPlayerABot( Bot ) )
				SurvivorBots.append( Bot )

		return SurvivorBots
	}

	function OnGameEvent_player_hurt_concise( params )
	{
		if ( "attackerentid" in params )
		{
			local attacker = EntIndexToHScript( params.attackerentid )
			local bot = GetPlayerFromUserID( params.userid )

			if ( attacker != null && bot != null )
			{
				local randomIntForVictim = RandomInt( 0, 10 )
				local randomIntForAttacker = RandomInt( 0, 6 )

				if ( attacker.IsSurvivor() && bot.IsSurvivor() && IsPlayerABot( bot ) && randomIntForVictim == 1 )
					ChatFriendlyFire_Victim( bot, attacker )

				if ( attacker.IsSurvivor() && IsPlayerABot( attacker ) && bot.IsSurvivor() && IsPlayerABot( bot ) && randomIntForAttacker == 1 )
					ChatFriendlyFire_Attacker( attacker, bot )
			}
		}
	}

	function OnGameEvent_player_death( params )
	{
		if ( params.victimname != "Infected" && EntIndexToHScript( params.attacker ) != null )
		{
			local victim = GetPlayerFromUserID( params.userid )
			local killer = GetPlayerFromUserID( params.attacker )

			if ( !victim.IsSurvivor() && killer.IsSurvivor() )
			{
				if ( RandomInt( 0, 8 ) == 1 )
					ChatOnKill( killer )

				if ( RandomInt( 0, 5 ) == 1 )
					ChatComplimentKiller( killer )
			}
		}
	}

	function OnGameEvent_player_incapacitated( params )
	{
		if ( "userid" in params )
		{
			local victim = GetPlayerFromUserID( params.userid )

			if ( victim.IsSurvivor() && IsPlayerABot( victim ) )
				if ( RandomInt( 0, 2 ) == 1 )
					ChatOnIncap( victim )
		}
	}

	function OnGameEvent_survivor_rescued( params )
	{
		if ( "rescuer" in params )
		{
			local rescuer = GetPlayerFromUserID( params.rescuer )
			local victim = GetPlayerFromUserID( params.victim )

			if ( victim.IsSurvivor() && IsPlayerABot( victim ) && IsPlayerABot( rescuer ) )
			{
				if ( RandomInt( 0, 2 ) == 1 )
					ChatOnRescue( victim, "victim" )
				else
					ChatOnRescue( rescuer, "rescuer" )
			}
		}
	}

	function OnGameEvent_upgrade_pack_begin( params )
	{
		if ( "userid" in params )
		{
			local bot = GetPlayerFromUserID( params.userid )

			if ( bot.IsSurvivor() && IsPlayerABot( bot ) )
			{
				if ( RandomInt( 0, 2 ) == 1 )
				{
					// TODO: Make specific lines for
					// fire and explosive ammo
					local deploy_lines =
					[
						"Deploying some ammo!",
						"Everyone stop, here's some deployable ammo!",
						"Upgradeable ammo being deployed!",
						"Deployed some cool ammo!",
						"Deploying the useless ammo!",
					];

					local len = deploy_lines.len() - 1
					Say( bot, deploy_lines[ RandomInt( 0, len ) ], false )
				}
			}
		}
	}

	// --------------------------------------------------------------------------
	// When making custom lines, to properly format correctly the text so that
	// it doesn't look like "don't shoot mePyri" or "Nice kill  Pyri",
	// look down below to follow how to format properly.
	// --------------------------------------------------------------------------
	// For the ChatFriendlyFire_Victim() function
	// [ attackerName ] = The attacker (Who shot the bot?)
	// --------------------------------------------------------------------------
	// For the ChatFriendlyFire_Attacker() function
	// [ victimName ] = the victim (Who was shot)
	// [ attackerName ] = The attacker (Who shot the bot?)
	// --------------------------------------------------------------------------
	// For the ChatComplimentKiller() function
	//  [ killerName ] = The killer (Who killed the SI?)
	// --------------------------------------------------------------------------
	// For the ChatOnKill() function
	// TBD
	// --------------------------------------------------------------------------
	// For the ChatOnIncap() function
	// ( victim )
	// victim = The bot that went down
	// --------------------------------------------------------------------------
	// For the ChatOnRescue() function
	// ( who, role )
	// who = Who is the rescuer or rescued
	// role = Are they the rescuer or the rescued?
	// --------------------------------------------------------------------------

	// Move these functions into a separate nut file later.

	function ChatOnIncap( victim )
	{
		local incap_lines =
		[
			"Help me!",
			"Where's my teammates?",
			"I've fallen and I can't get up",
			"I've fallen, help me!",
			"Shit, I'm down!",
			"Need some help over here.",
			"Can someone help me?",
			"This isn't my day, help!",
			"Ahh shit, I need some help.",
			"Yo, we're a team, come get me!",
			"I'm down!",
			"Hey y'all, I need some help!",
			"I don't like being on the ground, help me up!",
			"Because you guys didn't help me, I'm down!",
			"Don't you be leaving me behind, get me up!",
			"I screwed up big time, please help me up!",
			"Game is broken. My AI should be immune to damage!",
			"Valve didn't give me buddha or god.",
			"It's not a skill issue, help me up!",
			"It's just not going my way, please help me."
		];

		local len = incap_lines.len() - 1
		Say( victim, incap_lines[ RandomInt( 0, len ) ], false )
	}

	function ChatOnRescue( who, role )
	{
		local rescued_lines =
		[
			"Thanks playa!",
			"Thanks, it was getting dark and scarey in there.",
			"Thanks for getting me out of there.",
			"I owe you big for that!",
			"Thanks for rescuing me",
			"Back into the game, thanks man!",
			"Thank you.",
			"Thanks friend!",
			"I was getting scared, thanks!",
			"You're a great teammate to have!"
		];

		local rescuer_lines =
		[
			"We can't leave you behind, come on.",
			"We'll find you some items, come on.",
			"We need you, come one.",
			"Don't mention it.",
			"This is a team effort, now come on.",
			"I wasn't going to leave you here, let's go.",
			"You will recuse me next time?",
			"Come on, we got zombies to kill and shit.",
			"I missed you.",
			"Can you still shoot?",
		];

		local lines = ( role == "victim" ) ? rescued_lines : rescuer_lines;
		local len = lines.len() - 1
		Say( who, lines[ RandomInt( 0, len ) ], false )
	}

	function ChatFriendlyFire_Victim( victim, attacker )
	{
		local attackerName = attacker.GetPlayerName();
		local friendlyFireLines =
		[
			// No mention of Attacker's name
			"Quit shooting me.",
			"STOP... SHOOTING... ME!",
			"Want me to shoot you back?",
			"I'll stop helping you, if you keep that.",
			"Shoot the infected, not me.",
			"For crying out loud, stop it!",
			"Really? Shooting me isn't going to help.",
			"How did you NOT see me?!",
			"I have an outline, you dingus!",
			"You do that again, and I will bury you alive.",
			"Have you lost your mind?!",
			"Watch where you're shooting!",
			"Lets not shoot each other, please.",
			"Dont shoot me!",
			"You know, it's not alright that YOU'RE SHOOTING ME!",
			"What the!?",
			"I am not a zombie man, shoot the zombies!",
			"We are in the same team, man. COME ON!",
			"Dont be shooting me.",
			"Are you outta your mind, shootin' at me?",
			"Oh, Excuse  me? EXCUSE ME!",
			"Oh, where in the hell you think you shootin'!?",
			"DONT SHOOT ME!",
			"Why would you think shooting me is a good idea?",
			"YOU. ARE. SHOOTING. ME!",
			"Shootin' me? That's some crazy shit.",
			"Look, try shootin' some damn zombies instead of me!",
			"Lets not all start shootin' each other, now.",
			"Stop! I am getting pissed off!",
			"DO I LOOK LIKE ONE OF THEM?!",
			"Oh hell no boy, don't you be shooting me!",
			"GODDAMN IT, STOP SHOOTING ME!",
			"Oh hell no, do not shoot me!",
			"Unless you want to be kicked, stop shooting me!",
			"Damn! You suck at shooting.",
			"Dumbshit!",
			"Ass!",
			"Asshole!",
			"Kiss my ass!",
			"Is this some type of sick joke!?",
			"What the hell are you doing?!",
			"I'll votekick you if you do that again!",
			"Don't be messing with my aim!",
			"You're messing my aim up, stop!",
			"Come on now, seriously!?",
			"Man, cut that shit out!",
			"Cease and desist!",
			"You do know I also have a gun, right?",
			"You're an asshole when you're mad?",
			"Are you really going to shoot me?!",
			"Damn it, that hurts!",
			"Bite me!",
			"Ouch! That wasn't from an Infected...",
			"Who in the hell shot me?",
			"Somebody shot me!",
			"Oh sweet jesus, you shot me!",
			"Come on man, that's not funny anymore!",
			"Hey, I know who shot me, but I won't say who.",
			"What in the hell kind of strategy is that?",

			// Name first
			attackerName + ", can we not shoot each other?",
			attackerName + ", you suck at shooting.",
			attackerName + ", you are shooting me!",
			attackerName + ", watch your fire!",
			attackerName + ", did you mean to do that?",
			attackerName + " is a horrible shooter.",
			attackerName + ", why are you shooting me?",
			attackerName + " are you retarded or something?",
			attackerName + " are you dumb?",
			attackerName + " is this your first time playing?",
			attackerName + " is this your first game?",
			attackerName + "!",
			attackerName + ", settled down there, ya shot me.",
			attackerName + ", you are shooting me!",
			attackerName + ", just stop! Okay?",
			attackerName + "! What the hell is wrong with you?",

			// Name in middle
			"Goddamn it " + attackerName + " stop shooting me!",
			"Vote kick " + attackerName + ", he won't stop shooting.",
			"Please " + attackerName + ", stop it!",
			"Knock that shit off " + attackerName + "!",
			"Bite me " + attackerName + "!"

			// Name w/ ? or .
			"What did I do to you " + attackerName + "?",
			"What did I ever do to you " + attackerName + "?",
			"Why are you shooting me " + attackerName + "?",
			"What the hell are you doing " + attackerName + "?",
			"Really " + attackerName + "?",
			"Stop shooting me " + attackerName + "!",
			"Quit shooting me " + attackerName + "!",

			// Ending name
			"Knock that shit off " + attackerName,
			"Im putting you on blast " + attackerName,
			"Cut that shit out " + attackerName,
			"Imma throw a Molotov at you " + attackerName,
			"Quit shooting me " + attackerName,
			"Shoot the zombies " + attackerName,
			"Shoot the infected " + attackerName,
			"You're hurting me when you do that " + attackerName,
			"Might as well just take it... STOP IT " + attackerName,

			// insults from real games
			"what the fuck?",
			"shitbag!"
			"moron",
			"who let this blind kid play?",
			"suck my nuts!",
			"Tramppy!",
			"hoe",
			"stick to kiddie games, kiddo",
			"Go play minecraft kid",
			"your aim is shit",
			"I am Going to say the n word. not cool!",
			"punk.",
			"Yous a bitch!",
			"Ballsack sniffer",
			"griefing little shitbag",
			"ADMIN! " + attackerName + " is griefing!",
			"Admin system on the server? kick this dickwad!",
			"you little shit, kick " + attackerName,
			attackerName + ", go clean dishes.",
			attackerName + ", Fuck off!",
		];

		// Make the bot say something when attacked by a teammate
		local len = friendlyFireLines.len() - 1
		Say( victim, friendlyFireLines[ RandomInt( 0, len ) ], false )
	}

	function ChatFriendlyFire_Attacker( attacker, victim )
	{
		local attackerName = attacker.GetPlayerName();
		local victimName = victim.GetPlayerName();

		local attackerFriendlyFireLines =
		[
			// Apolegetic
			"Sorry, my bad!",
			"Misclick, sorry.",
			"please don't kick me.",
			"I won't do that again.",
			"It's my fault, I'm sorry."

			// Apolegetic w/ name
			victimName + ", I'm sorry.",

			// Hostile
			"Get out of my way next time!",
			"Get out of my way then!",
			"Next time, move your fat ass.",
			"Stop getting in my way!",
			"You're the one standing in fromt of me.",
		];

		// Make the attacker bot say something
		local len = attackerFriendlyFireLines.len() - 1
		Say( attacker, attackerFriendlyFireLines[ RandomInt( 0, len ) ], false )
	}

	function ChatComplimentKiller( killer )
	{
		local SurvivorBots = GetAllSurvivorBots()
		local killerName = killer.GetPlayerName();

		// Filter out the killer from the list of bots
		local Bot_NotKiller = []
		for ( local i = 0; i < SurvivorBots.len(); i++ )
		{
			local bot = SurvivorBots[ i ]
			if ( bot != killer )
				Bot_NotKiller.append( bot )
		}

		// If the bot is not the killer, have 'em compliment the killer
		if ( Bot_NotKiller.len() > 0 )
		{
			local bot = Bot_NotKiller[ RandomInt( 0, Bot_NotKiller.len() -1 ) ]

			local compliment_killer =
			[
				// Supportive
				"Nice one!",
				"Good job!",
				"Good one!",
				"Great!",
				"You beat 'em!",
				"You beat their ass!",
				"Nice shot!",
				"Sick kill.",
				"Good kill.",
				"Sweet shot!",
				"Great shot!",
				"Sweet kill dude!",
				"Nice one dude!",
				"Cool!",
				"Damn, I'm impressed.",
				"Nice shot youngin'.",
				"Ooo, alright nice.",
				"That was a nice kill.",
				"You're taking charge, man!",
				"Impressive.",
				"Good shot!",
				"That's some piece of work!",
				"Amazing kill, comrade!",
				"Good shootin'",
				"Nice shot mate!",
				"Fine shootin'",
				"Fine shooting!",
				"Amazing shot!",
				"That's a good kill there!"

				// Support w/ Name
				"Amazing kill " + killerName,
				"Good kill " + killerName,
				"Awesome kill " + killerName,
				"Great kill " + killerName + ".",
				"Good shot " + killerName,
				"That's a good one " + killerName,
				"That's a good kill " + killerName,
				"You a natural killer " + killerName,
				"You're a natural killer " + killerName,
				killerName + ", that was an epic kill.",
				killerName + ", we should play on Expert more.",
				killerName + ", damn... you got it!",
				killerName + " you're an amazing teammate to have!",
				"Damn" + killerName + ", you are tearing them up!",
				"Nice shot " + killerName + ". Great one!",
				"Okay, keep it at " + killerName + ".",
				"Amazing play " + killerName + "!",
				"That was outstanding " + killerName + "!",
				"You a good teammate " + killerName + ".",
				"Great job " + killerName + ". You got it in you!",
				"outstanding " + killerName + "!",
				"cool shot " + killerName,

				// Jealous
				"I thought I got that one, oh well.",
				"Pffft.",
				"I could do that with my eyes closed.",
				"I suppose you got that one.",
				"I doubt you got that one.",
				"What??? You just lucky that you got that one",
				"Whatever. I should've got that.",
				"Whatever.",
				"I can kill one too, so what?",
				"Borning kill.",
				"Meh, I rate that as a 2/10 kill.",
				"I could kill a special with the Pistols.",
				"I would've biled the special... What? It's funny.",

				// Jealous w/ Name
				"You sure you got that kill " + killerName + "?",
				"You cheating " + killerName + "? I swear, you are.",
				"How did you get that " + killerName + "?",
				"Bullshit! That was my kill, " + killerName,
				"Are you kidding me " + killerName + "? I got that kill, not you!",
				"Gimme your hacks " + killerName + "!",
				"Hey " + killerName + ", whats your setup? I want to know.",
				"Yo " + killerName + ", where did you find your skill?",
				"What? " + killerName + ", what the hell was that? How?",

				// Calling BS
				"Wait What? How?",
				"What!? Bullshit.",
				"Oh bullshit, that was my kill!",
				"WHAT? That was my kill.",
				"That was mine! come one!",
				"steal killing bitch",
				"You killed them before me!?",
				"i did most damage, I should've gotten it",
				"u bullshitting me? that was mine!",
				"HORSE BALLS! THAT WAS MY KILL!",
				"You dick! That was my kill!",
			];

			// If the random bot is not incapped, hanging, near death or no tanks active, they can speak.
			local len = compliment_killer.len() - 1
			if ( !bot.IsIncapacitated() && !bot.IsHangingFromLedge() && !bot.IsOnThirdStrike() && !Director.IsTankInPlay() )
				Say( bot, compliment_killer[ RandomInt( 0, len ) ], false )
		}
	}

	function ChatOnKill( killer )
	{
		local killer_lines =
		[
			"Gotcha, you slow cousin.",
			"Y'all should attack in coordination.",
			"Yawn...",
			"Are we playing on easy mode, or something?",
			"Should've tried harded.",
			"Bam!",
			"Dead!",
			"Got it!",
			"It's dead!",
			"Clobbered!",
			"Popped a cap in it's ass!",
			"I wasted you!",
			"Takes more to take me down.",
			"Infected lame brains.",
			"You tried!",
			"Easy.",
			"L.",
			"L + Ratio + Ur Dead.",
			"GG NO RE",
			"suck it.",
			"Lame brains.",
			"Pow! Got it.",
			"One less Special to worry about!",
			"What's so special about you?",
			"I think he just got his ass kicked!",
			"Someone got their ass kicked!",
			"Zombie kill of the week? Me!",
			"I'm the best killer out there!",
			"No friend requests please, i'm just skilled.",
			"Not so special anymore?",
			"You just suck!",
			"Domination pal, look into it!",
			"You just got dominated knucklehead!",
			"You gotta hide faster next time!",
			"Don't mean to be picking on you, but you're bad!",
			"Ain't so special anymore, huh?",
			"Whooo, makin' bacon!",
			"That wasn't even close.",
			"More where that came from!",
			"It's starting to bore me on how much you suck!",
			"It's starting to bore me on easy it is.",
		];

		local len = killer_lines.len() - 1
		if ( IsPlayerABot( killer ) )
			Say( killer, killer_lines[ RandomInt( 0, len ) ], false )
	}
}

__CollectEventCallbacks( BotTextChatter, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );