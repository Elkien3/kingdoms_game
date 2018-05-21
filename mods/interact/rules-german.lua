--The actual rules.
local language = "german" --must be all lowercase
local yes = "Ja."
local no = "Nein."
rule_table[language] = {rules = [[
Rules:

1. Keine Zerstorung.
2. Keine gehackten Clients.
3. Kein Fluchen oder Beleidigungen gegenuber anderen Spielern.
4. Kein Familienrollenspiel.
5. Keine Datierung.
6. Fragen Sie nicht nach mehr Privilegien oder um ein Administrator zu sein. Fragen Sie auch nicht nach Dingen.
7. PVP ist nicht erlaubt.
]],

--The questions on the rules, if the quiz is used.
--The checkboxes for the first 4 questions are in config.lua
question1 = "Ist PVP erlaubt?",
question2 = "Ist Familienrollenspiel erlaubt?",
question3 = "Solltest du nett zu allen Spielern sein?",
question4 = "Sollten Sie nach allen Privilegien fragen, die Sie konnen?",
multiquestion = "Welche davon ist eine Regel?",

--The answers to the multiple choice questions. Only one of these should be true.
mq_answer1 = "Keine Datierung!",
mq_answer2 = "PVP ist erlaubt.",
mq_answer3 = "Sei unhoflich zu anderen Spielern.",

--The first screen--
--The text at the top.
s1_header = "Hallo, willkommen auf diesem Server!",
--Lines one and two. Make sure each line is less than 70 characters, or they will run off the screen.
s1_l2 = "Konnten Sie mir bitte sagen, ob Sie zerstoren mochten oder nicht?",
s1_l3 = "",
--The buttons. Each can have 15 characters, max.
s1_b1 = "Nein, ich nicht.",
s1_b2 = "Ja, mache ich!",

--The message to send kicked griefers.
msg_grief = "Probiere Singleplayer aus, wenn du gerne zerstorst, denn dann zerstorst du nur deine eigenen Sachen!",

--The second screen--
--Lines one and two. Make sure each line is less than 70 characters, or they will run off the screen.
s2_l1 = "Willst du also interagieren oder willst du dich nur auf dem Server umsehen?",
s2_l2 = "",
--The buttons. These ones can have a maximum of 26 characters.
s2_b1 = "Ja, ich mochte interagieren!",
s2_b2 = "Ich mochte mich nur umsehen.",

--The message the player is sent if s/he is just visiting.
visit_msg = "Viel Spass beim Schauen! Wenn Sie interagieren mochten, geben Sie einfach /rules ein, und Sie konnen den Vorgang erneut durchlaufen!",

--The third screen--
--The header for the rules box, this can have 60 characters, max.
s3_header = "Hier sind die Regeln:",

--The buttons. Each can have 15 characters, max.
s3_b1 = "Ich stimme zu",
s3_b2 = "Nein",

--The message to send players who disagree when they are kicked for disagring with the rules.
disagree_msg = "Tschuss dann! Sie mussen den Regeln zustimmen, um auf dem Server zu spielen.",

--The back to rules button. 13 characters, max.
s4_to_rules = "Zuruck zu den Regeln",

--The header for screen 4. 60 characters max, although this is a bit of a squash. I recomend 55 as a max.
s4_header = "Zeit fur ein Quiz uber die Regeln!",

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

s4_submit = "Einreichen!",

--The message to send the player if reshow is the on_wrong_quiz option.
quiz_try_again_msg = "Versuch es noch einmal.",
--The message sent to the player if rules is the on_wrong_quiz option.
quiz_rules_msg = "Schau dir die Regeln noch einmal an:",
--The kick reason if kick is the on_wrong_quiz option.
wrong_quiz_kick_msg = "Achten Sie beim nachsten Mal mehr Aufmerksamkeit!",
--The message sent to the player if nothing is the on_wrong_quiz option.
quiz_fail_msg = "Du hast das Quiz nicht bestanden.",

--The messages send to the player after interact is granted.
interact_msg1 = "Danke, dass du die Regeln akzeptiert hast, jetzt kannst du interagieren.",
interact_msg2 = "Frohliches Gebaude!"
}