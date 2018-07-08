--The actual rules.
local language = "francais" --must be all lowercase
local yes = "Oui."
local no = "Non."
rule_table[language] = {
secondaryname = nil, --secondary name, usually the language name in english, or in the actual language.

rules = [[
Rules:

1. PVP est autorisé. Ne pas "Combat log"!
2. Ne soyez pas * trop * cruel, destructeur ou inapproprié.
3. Continuez à jurer au minimum, et ne spammez pas.
4. Pas de "Rencontres" ou similaire.
5. Do not destroy entire forests without replanting them.
6. Si vous attaquez un royaume alors que ses membres sont hors ligne, vous ne pouvez pas détruire ou voler beaucoup.
7. S'il vous plaît garder vos bâtiments de style médiéval, et suivez les lois de la physique.
8. Les clients piratés ou csms qui donnent un avantage pvp ne sont pas autorisés.

Rappelez-vous: Une certaine destruction pendant la guerre est O.K. mais, ne soyez pas * trop * cruel
]],

--The questions on the rules, if the quiz is used.
--The checkboxes for the first 4 questions are in config.lua
question1 = "Le PVP est-il autorisé?",
question2 = "Devriez-vous replanter après avoir coupé des arbres?",
question3 = "Pouvez-vous donner aux filles en ligne de grands smooches en ligne?",
question4 = "Pouvez-vous parfois détruire certaines des choses de votre ennemi?",
multiquestion = "Quel style de construction utiliser?",

--The answers to the multiple choice questions. Only one of these should be true.
mq_answer1 = "Gratte-ciel modernes, super grands.",
mq_answer2 = "Les stations spatiales, dans le ciel.",
mq_answer3 = "Médiéval, sans pièces volantes.",

--The first screen--
--The text at the top.
s1_header = "Bonjour, bienvenue dans Persistent Kingdoms!",
--Lines one and two. Make sure each line is less than 70 characters, or they will run off the screen.
s1_l2 = "Pourriez-vous s'il vous plaît me dire si vous aimez 'grief' beaucoup?",
s1_l3 = "'griefing' détruit des lieux et fait des dégâts.",
--The buttons. Each can have 15 characters, max.
s1_b1 = "Non.",
s1_b2 = "Oui!",

--The message to send kicked griefers.
msg_grief = "Un * lot * de 'griefing' est méprisé, bien que certaines destructions de guerre puissent être acceptables.",

--The second screen--
--Lines one and two. Make sure each line is less than 70 characters, or they will run off the screen.
s2_l1 = "Alors, voulez-vous interagir, ou voulez-vous juste regarder autour du serveur?",
s2_l2 = "",
--The buttons. These ones can have a maximum of 26 characters.
s2_b1 = "Oui, je veux interagir!",
s2_b2 = "Je veux juste regarder autour.",

--The message the player is sent if s/he is just visiting.
visit_msg = "Passez un bon moment à regarder autour! Si vous voulez interagir, tapez '/rules francais', et vous pouvez recommencer le processus!",

--The third screen--
--The header for the rules box, this can have 60 characters, max.
s3_header = "Here are the rules:",

--The buttons. Each can have 15 characters, max.
s3_b1 = "je suis d'accord",
s3_b2 = "je ne suis pas d'accord",

--The message to send players who disagree when they are kicked for disagring with the rules.
disagree_msg = "Au revoir alors! Vous devez accepter les règles pour jouer sur le serveur.",

--The back to rules button. 13 characters, max.
s4_to_rules = "Retour aux règles",

--The header for screen 4. 60 characters max, although this is a bit of a squash. I recomend 55 as a max.
s4_header = "Temps pour un quiz sur les règles!",

--Since the questions are intrinsically connected with the rules, they are to be found in rules.lua
--The trues are limited to 24 characters. The falses can have 36 characters.

s4_question1_true = yes,
s4_question1_false = no,
s4_question2_true = yes,
s4_question2_false = no,
s4_question3_true = yes,
s4_question3_false = no,
s4_question4_true = yes,
s4_question4_false = no,

s4_submit = "s'inscrire!",

--The message to send the player if reshow is the on_wrong_quiz option.
quiz_try_again_msg = "Essaye encore.",
--The message sent to the player if rules is the on_wrong_quiz option.
quiz_rules_msg = "Jetez un autre regard sur les règles:",
--The kick reason if kick is the on_wrong_quiz option.
wrong_quiz_kick_msg = "Portez plus d'attention la prochaine fois!",
--The message sent to the player if nothing is the on_wrong_quiz option.
quiz_fail_msg = "Vous avez répondu incorrectement à une question. tapez '/rules francais' pour réessayer. (lisez-les attentivement)",

--The messages send to the player after interact is granted.
interact_msg1 = "Merci d'avoir accepté les règles, vous êtes maintenant en mesure d'interagir avec les choses.",
interact_msg2 = "S'amuser! Faites /guide pour obtenir de l'aide pour commencer!",
}