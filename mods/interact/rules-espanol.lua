--The actual rules.
local language = "espanol" --must be all lowercase
local yes = "Si."
local no = "No."
rule_table[language] = {
secondaryname = "spanish", --secondary name, usually the language name in english, or in the actual language.

rules = [[
Rules:

1. PVP está permitido. No te vayas durante una pelea (Combat Log)!
2. No seas * excesivamente * cruel, destructivo o inapropiado.
3. Sigue jurando al mínimo y no hagas spam.
4. No se permiten citas románticas
5. No destruyas bosques enteros sin replantar.
6. Si atacas un reino mientras sus miembros están fuera de línea, no podrás destruir o robar mucho.
7. Por favor, mantenga sus construcciones en tiempos medievales y siga las leyes de la física.
8. Los clients de hackers o mods que dan una ventaja de pvp no están permitidos.

Recuerde: una pequeña destrucción durante la guerra es O.K. simplemente "No seas * excesivamente * cruel"
]],

--The questions on the rules, if the quiz is used.
--The checkboxes for the first 4 questions are in config.lua
question1 = "¿PVP está permitido?",
question2 = "¿Deberías replantar después de cortar los árboles?",
question3 = "¿Puedes dar a las chicas en línea grandes besos en línea?",
question4 = "¿Puedes destruir un poco las cosas de tus enemigos de vez en cuando?",
multiquestion = "¿Qué estilo de construcción usar?",

--The answers to the multiple choice questions. Only one of these should be true.
mq_answer1 = "Rascacielos modernos y súper altos.",
mq_answer2 = "Estaciones espaciales, en el cielo.",
mq_answer3 = "Medieval, sin partes voladoras.",

--The first screen--
--The text at the top.
s1_header = "¡Hola, bienvenidos a Persistent Kingdoms!",
--Lines one and two. Make sure each line is less than 70 characters, or they will run off the screen.
s1_l2 = "¿Podría decirme si le gusta mucho 'grief'?",
s1_l3 = "'Griefing' es destruir lugares y en general hacer un desastre.",
--The buttons. Each can have 15 characters, max.
s1_b1 = "No, yo no.",
s1_b2 = "Si!",

--The message to send kicked griefers.
msg_grief = "A * lot * of 'griefing' es malo, pero se permite cierta destrucción durante una guerra.",

--The second screen--
--Lines one and two. Make sure each line is less than 70 characters, or they will run off the screen.
s2_l1 = "Entonces, ¿quieres 'interact', o solo quieres mirar alrededor del servidor?",
s2_l2 = "",
--The buttons. These ones can have a maximum of 26 characters.
s2_b1 = "Sí, quiero 'interact'!",
s2_b2 = "Solo quiero mirar alrededor.",

--The message the player is sent if s/he is just visiting.
visit_msg = "¡Diviértete mirando a tu alrededor! Si desea 'interact', simplemente escriba '/rules espanol', ¡y podrá seguir el proceso de nuevo!",

--The third screen--
--The header for the rules box, this can have 60 characters, max.
s3_header = "Estas son las reglas:",

--The buttons. Each can have 15 characters, max.
s3_b1 = "estoy de acuerdo",
s3_b2 = "Estoy en desacuerdo",

--The message to send players who disagree when they are kicked for disagring with the rules.
disagree_msg = "Adiós! Debes aceptar las reglas para jugar en el servidor.",

--The back to rules button. 13 characters, max.
s4_to_rules = "Regrese a las reglas",

--The header for screen 4. 60 characters max, although this is a bit of a squash. I recomend 55 as a max.
s4_header = "¡Hora de una prueba sobre las reglas!",

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

s4_submit = "¡Enviar!",

--The message to send the player if reshow is the on_wrong_quiz option.
quiz_try_again_msg = "Tener otra oportunidad.",
--The message sent to the player if rules is the on_wrong_quiz option.
quiz_rules_msg = "Eche otro vistazo a las reglas:",
--The kick reason if kick is the on_wrong_quiz option.
wrong_quiz_kick_msg = "¡Presta más atención la próxima vez!",
--The message sent to the player if nothing is the on_wrong_quiz option.
quiz_fail_msg = "Respondió una pregunta incorrectamente. escriba '/rules espanol' para intentar de nuevo. (léelos con cuidado)",

--The messages send to the player after interact is granted.
interact_msg1 = "Thank you for accepting the rules, now you can interact with things.",
interact_msg2 = "¡Que te diviertas! ¡Haz '/guide' para obtener ayuda para comenzar! (está en inglés)",
}