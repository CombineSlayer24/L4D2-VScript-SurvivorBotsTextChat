Msg( "-----------------------------------\n" );
Msg( "  Bot Text Chat Script Initialized\n"  );
Msg( "-----------------------------------\n" );

// TODO:
// --------------------------------------------------------------------------
// Chat when they go down
// Chat when they die
// Chat when they are low on health (Begging to be healed)
// Chat when they are on 3rd strike
// Chat when they get rescued
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

			// attacker.IsSurvivor() spits errors out, fix later
			if ( attacker != null )
				if ( attacker.IsSurvivor() && bot.IsSurvivor() && IsPlayerABot( bot ) && RandomInt( 0, 10 ) == 1 )
					ChatSpeakFriendlyFire( bot, attacker )
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
					ChatSpeakOnKill( killer )

				if ( RandomInt( 0, 5 ) == 1 )
					ChatComplimentOnKiller( killer )
			}
		}
	}

	// --------------------------------------------------------------------------
	// When making custom lines, to properly format correctly the text so that
	// it doesn't look like "don't shoot mePyri" or "Nice kill  Pyri",
	// look down below for ff_lines or more to follow how to format properly.
	// --------------------------------------------------------------------------
	// For the ChatSpeakFriendlyFire() function
	// [ attackerName ] = The attacker (Who shot the bot?)
	// --------------------------------------------------------------------------
	// For the ChatComplimentOnKiller() function
	//  [ killerName ] = The killer (Who killed the SI?)
	// --------------------------------------------------------------------------
	// For the ChatSpeakOnKill() function
	// TBD
	// --------------------------------------------------------------------------
	// For the ChatSpeakOnIncap() function
	// WORK IN PROGRESS
	// --------------------------------------------------------------------------

	function ChatSpeakFriendlyFire( victim, attacker )
	{
		local attackerName = attacker.GetPlayerName();
		local ff_lines =
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

			// Name first
			attackerName + ", can we not shoot each other?",
			attackerName + ", you suck at shooting.",
			attackerName + ", you are shooting me!",
			attackerName + ", watch your fire!",
			attackerName + ", did you mean to do that?",
			attackerName + " is a horrible shooter.",
			attackerName + ", why are you shooting me?",
			attackerName + " are you retarded or something?",
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
			"moron",
			"who let this blind kid play?",
			"stick to kiddie games, kiddo",
			"Go play minecraft kid",
			attackerName + ", go clean dishes.",
			attackerName + ", Fuck off!.",
		];

		// Make the bot say something when attacked by a teammate
		Say( victim, ff_lines[ RandomInt( 0, ff_lines.len() -1 ) ], false )
	}

	function ChatComplimentOnKiller( killer )
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

				// Support w/ Name
				"Amazing kill " + killerName,
				"Good kill " + killerName,
				"Awesome kill " + killerName,
				"Great kill " + killerName + ".",
				"Good shot " + killerName,
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
				"bullshitting prick, that was mine!",
				"HORSE BALLS! THAT WAS MY KILL, YOU DICKBAG!",
			];

			// If the random bot is not incapped, hanging, near death or no tanks active, they can speak.
			if ( !bot.IsIncapacitated() && !bot.IsHangingFromLedge() && !bot.IsOnThirdStrike() && !Director.IsTankInPlay() )
				Say( bot, compliment_killer[ RandomInt( 0, compliment_killer.len() -1 ) ], false )
		}
	}

	function ChatSpeakOnKill( killer )
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
			"Pow! Got it."
		];

		if ( IsPlayerABot( killer ) )
			Say( killer, killer_lines[ RandomInt( 0, killer_lines.len() -1 ) ], false )
	}

	function ChatSpeakOnIncap( incapped )
	{
		local incap_lines =
		[
			"Help me!",
			"Where's my teammates?",
			"I've fallen and I can't get up",
			"I've fallen, help me!",
			"Shit, I'm down!",
			"Need some help over here.",
		];

		if ( IsPlayerABot( incapped ) && incapped.IsIncapacitated() )
			Say( incapped, incap_lines[ RandomInt( 0, incap_lines.len() -1 ) ], false )
	}
}

__CollectEventCallbacks( BotTextChatter, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener );