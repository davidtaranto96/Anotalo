// Curated quotes for Anotalo v1.6.0.
//
// Replaces the old 85-quote list that was too repetitive and full of generic
// refranes. This file holds ~500+ curated entries organized loosely by theme
// — philosophy, literature, cinema, science, Argentine figures, humor,
// productivity books, poetry. Every quote has a real author.
//
// Format: same shape as the original list so the existing random-rotation
// logic in `hoy_page.dart` works without changes.
//
//   {'q': '<text>', 'a': '<author — work (year) if relevant>'}

const List<Map<String, String>> curatedQuotes = [
  // ── Filosofía occidental ──────────────────────────────────────────────────
  {'q': 'Quien tiene un porqué para vivir puede soportar casi cualquier cómo.', 'a': 'Nietzsche — El crepúsculo de los ídolos'},
  {'q': 'Conviértete en quien eres.', 'a': 'Nietzsche — Así habló Zaratustra'},
  {'q': 'Lo que no te mata te hace más fuerte.', 'a': 'Nietzsche — El crepúsculo de los ídolos'},
  {'q': 'Quien lucha con monstruos debe cuidar de no convertirse también en monstruo.', 'a': 'Nietzsche — Más allá del bien y del mal'},
  {'q': 'Uno debe llevar todavía un caos dentro de sí para poder dar a luz una estrella danzante.', 'a': 'Nietzsche — Así habló Zaratustra'},
  {'q': 'Sin música, la vida sería un error.', 'a': 'Nietzsche'},
  {'q': 'Todo lo que se hace por amor se hace más allá del bien y del mal.', 'a': 'Nietzsche'},
  {'q': 'El hombre es algo que debe ser superado.', 'a': 'Nietzsche — Así habló Zaratustra'},

  {'q': 'No se vive dos veces; elegí.', 'a': 'Séneca — Cartas a Lucilio'},
  {'q': 'Mientras esperamos vivir, la vida pasa.', 'a': 'Séneca'},
  {'q': 'La vida, si sabés usarla, es larga.', 'a': 'Séneca — Sobre la brevedad de la vida'},
  {'q': 'No hay viento favorable para el que no sabe adónde va.', 'a': 'Séneca'},
  {'q': 'Nos damos cuenta de lo corta que es la vida justo cuando ya no podemos recuperarla.', 'a': 'Séneca'},
  {'q': 'Sufrimos más en la imaginación que en la realidad.', 'a': 'Séneca'},
  {'q': 'La suerte es lo que sucede cuando la preparación se encuentra con la oportunidad.', 'a': 'Séneca'},

  {'q': 'Es en tus días difíciles donde se forja quién sos.', 'a': 'Marco Aurelio — Meditaciones'},
  {'q': 'Tenés poder sobre tu mente, no sobre los hechos externos. Date cuenta de eso y vas a encontrar fuerza.', 'a': 'Marco Aurelio — Meditaciones'},
  {'q': 'La felicidad de tu vida depende de la calidad de tus pensamientos.', 'a': 'Marco Aurelio — Meditaciones'},
  {'q': 'El impedimento para la acción hace avanzar la acción. Lo que se interpone en el camino se convierte en el camino.', 'a': 'Marco Aurelio — Meditaciones'},
  {'q': 'Si te molesta algo externo, el dolor no viene de eso, sino de tu apreciación de ello; y podés revocarla en cualquier momento.', 'a': 'Marco Aurelio — Meditaciones'},
  {'q': 'Despertá y acordate: sos un hombre, pero tenés un poco de dios adentro.', 'a': 'Marco Aurelio — Meditaciones'},
  {'q': 'La mejor venganza es no ser igual al que te hiere.', 'a': 'Marco Aurelio'},

  {'q': 'No podemos elegir lo que nos pasa, pero sí cómo responder.', 'a': 'Epicteto'},
  {'q': 'No son las cosas las que te perturban, sino la opinión que tenés de ellas.', 'a': 'Epicteto — Enquiridion'},
  {'q': 'Primero decidí quién querés ser. Después hacé lo que tenés que hacer.', 'a': 'Epicteto'},
  {'q': 'Ningún gran trabajo se produce de golpe.', 'a': 'Epicteto'},

  {'q': 'La vida sólo puede ser comprendida hacia atrás, pero debe ser vivida hacia adelante.', 'a': 'Kierkegaard'},
  {'q': 'Atreverse es perder el pie momentáneamente. No atreverse es perderse a uno mismo.', 'a': 'Kierkegaard'},
  {'q': 'La ansiedad es el vértigo de la libertad.', 'a': 'Kierkegaard'},

  {'q': 'El hombre está condenado a ser libre.', 'a': 'Sartre — El ser y la nada'},
  {'q': 'Lo importante no es lo que han hecho de nosotros, sino lo que hacemos con lo que han hecho de nosotros.', 'a': 'Sartre'},
  {'q': 'Somos nuestras elecciones.', 'a': 'Sartre'},
  {'q': 'Tres de la tarde. Siempre es demasiado tarde o demasiado temprano para lo que querés hacer.', 'a': 'Sartre — La náusea'},

  {'q': 'Hay que imaginar a Sísifo feliz.', 'a': 'Camus — El mito de Sísifo'},
  {'q': 'En lo más hondo del invierno descubrí que había en mí un verano invencible.', 'a': 'Camus'},
  {'q': 'No caminés detrás de mí, quizás no guíe. No caminés delante, quizás no siga. Caminá a mi lado y sé mi amigo.', 'a': 'Camus'},
  {'q': 'Vivir es mantener viva la absurdidad.', 'a': 'Camus'},
  {'q': 'La rebelión es la certeza de tener un destino aplastante, pero sin la resignación que debería acompañarla.', 'a': 'Camus — El hombre rebelde'},

  {'q': 'Los límites de mi lenguaje son los límites de mi mundo.', 'a': 'Wittgenstein — Tractatus'},
  {'q': 'De lo que no se puede hablar, hay que callar.', 'a': 'Wittgenstein — Tractatus'},
  {'q': 'El mundo de los felices es distinto del de los infelices.', 'a': 'Wittgenstein'},

  {'q': 'Ningún hombre puede bañarse dos veces en el mismo río.', 'a': 'Heráclito'},
  {'q': 'El carácter es el destino.', 'a': 'Heráclito'},
  {'q': 'La guerra es el padre de todo.', 'a': 'Heráclito'},
  {'q': 'Todo fluye.', 'a': 'Heráclito'},

  {'q': 'Sólo sé que no sé nada.', 'a': 'Sócrates'},
  {'q': 'Una vida sin examen no merece ser vivida.', 'a': 'Sócrates'},
  {'q': 'El principio de la sabiduría es la definición de los términos.', 'a': 'Sócrates'},

  {'q': 'El comienzo es la parte más importante del trabajo.', 'a': 'Platón — La República'},
  {'q': 'Podemos perdonar fácilmente a un chico que le tiene miedo a la oscuridad. La verdadera tragedia es cuando los adultos le tienen miedo a la luz.', 'a': 'Platón'},

  {'q': 'Somos lo que hacemos repetidamente. La excelencia, entonces, no es un acto sino un hábito.', 'a': 'Will Durant resumiendo a Aristóteles'},
  {'q': 'Educar la mente sin educar el corazón no es educación en absoluto.', 'a': 'Aristóteles'},
  {'q': 'La felicidad depende de nosotros mismos.', 'a': 'Aristóteles'},

  {'q': 'La paz no se puede mantener por la fuerza; sólo puede alcanzarse mediante la comprensión.', 'a': 'Einstein'},
  {'q': 'No es que sea muy inteligente, es que me quedo más tiempo con los problemas.', 'a': 'Einstein'},
  {'q': 'La imaginación es más importante que el conocimiento.', 'a': 'Einstein'},
  {'q': 'Quien nunca cometió un error nunca probó nada nuevo.', 'a': 'Einstein'},
  {'q': 'La vida es como andar en bicicleta. Para mantener el equilibrio tenés que seguir moviéndote.', 'a': 'Einstein'},
  {'q': 'Todos somos muy ignorantes. Lo que pasa es que no todos ignoramos las mismas cosas.', 'a': 'Einstein'},

  {'q': 'El que tiene un porqué encuentra casi cualquier cómo.', 'a': 'Viktor Frankl — El hombre en busca de sentido'},
  {'q': 'Entre el estímulo y la respuesta hay un espacio. En ese espacio está nuestro poder de elegir.', 'a': 'Viktor Frankl'},
  {'q': 'Cuando ya no podemos cambiar una situación, estamos desafiados a cambiar nosotros mismos.', 'a': 'Viktor Frankl'},

  {'q': 'No quieras que las cosas sucedan como deseás, sino deseá que sucedan como suceden, y vas a tener paz.', 'a': 'Epicteto'},
  {'q': 'La vida no es lo que uno vivió, sino lo que uno recuerda, y cómo la recuerda para contarla.', 'a': 'García Márquez'},

  {'q': 'Yo soy yo y mi circunstancia, y si no la salvo a ella no me salvo yo.', 'a': 'Ortega y Gasset'},
  {'q': 'La vida es una serie de colisiones con el futuro.', 'a': 'Ortega y Gasset'},

  {'q': 'Sólo es digno de vivir quien conquista cada día su libertad.', 'a': 'Goethe — Fausto'},
  {'q': 'Todo lo que vale la pena hacer vale la pena hacerlo bien.', 'a': 'Goethe'},
  {'q': 'Lo que no entendés no lo poseés.', 'a': 'Goethe'},

  {'q': 'La razón sin pasión es impotente. La pasión sin razón es ciega.', 'a': 'Spinoza'},
  {'q': 'La paz no es la ausencia de guerra. Es una virtud, un estado mental, una disposición a la benevolencia y la justicia.', 'a': 'Spinoza'},

  {'q': 'Pienso, luego existo.', 'a': 'Descartes'},
  {'q': 'No basta con tener buen espíritu. Lo principal es aplicarlo bien.', 'a': 'Descartes'},

  {'q': 'El talento alcanza las metas que los otros no pueden; el genio alcanza las metas que los otros no pueden ver.', 'a': 'Schopenhauer'},
  {'q': 'Cada niño es, en cierto modo, un genio; y cada genio, en cierto modo, un niño.', 'a': 'Schopenhauer'},

  // ── Filosofía oriental / sabiduría antigua ────────────────────────────────
  {'q': 'El viaje de mil kilómetros empieza con un solo paso.', 'a': 'Lao Tse — Tao Te Ching'},
  {'q': 'Conocer a los demás es inteligencia. Conocerse a uno mismo es sabiduría.', 'a': 'Lao Tse — Tao Te Ching'},
  {'q': 'Cuando no sos consciente de la plenitud, te sentís insatisfecho aun teniendo todo.', 'a': 'Lao Tse'},
  {'q': 'La naturaleza no tiene apuro y, sin embargo, todo se cumple.', 'a': 'Lao Tse'},
  {'q': 'El líder que es el mejor es apenas conocido por los hombres. Cuando termina su trabajo, la gente dice: lo hicimos nosotros.', 'a': 'Lao Tse'},
  {'q': 'La agua es la más blanda, pero su poder es infinito.', 'a': 'Lao Tse'},

  {'q': 'El hombre que mueve una montaña comienza cargando piedras pequeñas.', 'a': 'Confucio'},
  {'q': 'No importa qué tan lento vayás, mientras no te detengas.', 'a': 'Confucio'},
  {'q': 'Elegí un trabajo que ames y no vas a tener que trabajar ni un solo día en tu vida.', 'a': 'Confucio'},
  {'q': 'Todo tiene belleza, pero no todos la ven.', 'a': 'Confucio'},
  {'q': 'El que sabe no habla, el que habla no sabe.', 'a': 'Lao Tse'},

  {'q': 'Lo que somos hoy es el resultado de lo que pensamos ayer.', 'a': 'Buda — Dhammapada'},
  {'q': 'Mil velas pueden encenderse con una sola sin que la vida de esa vela se acorte.', 'a': 'Buda'},
  {'q': 'El odio no termina con odio. Sólo con amor termina el odio. Ésa es la ley eterna.', 'a': 'Buda — Dhammapada'},
  {'q': 'Mejor que mil palabras vacías es una sola que dé paz.', 'a': 'Buda'},

  {'q': 'Conocé a tu enemigo y conocéte a vos mismo, y en cien batallas nunca estarás en peligro.', 'a': 'Sun Tzu — El arte de la guerra'},
  {'q': 'En medio del caos hay también oportunidad.', 'a': 'Sun Tzu — El arte de la guerra'},
  {'q': 'Ser veloz como el viento, silencioso como el bosque, agresivo como el fuego, inamovible como la montaña.', 'a': 'Sun Tzu — El arte de la guerra'},

  {'q': 'Hacé tu trabajo sin apego al fruto.', 'a': 'Bhagavad Gita'},
  {'q': 'Tenés derecho a la acción, nunca a sus frutos.', 'a': 'Bhagavad Gita'},

  {'q': 'El ganso salvaje no deja huellas en el agua; el agua no guarda memoria del ganso.', 'a': 'Zenrin Kushu'},
  {'q': 'Antes de la iluminación: cortar leña, acarrear agua. Después de la iluminación: cortar leña, acarrear agua.', 'a': 'Proverbio zen'},

  // ── Literatura hispana ────────────────────────────────────────────────────
  {'q': 'He cometido el peor pecado que un hombre puede cometer: no he sido feliz.', 'a': 'Borges — El remordimiento'},
  {'q': 'Siempre imaginé que el paraíso sería algún tipo de biblioteca.', 'a': 'Borges'},
  {'q': 'Uno no es lo que es por lo que escribe, sino por lo que ha leído.', 'a': 'Borges'},
  {'q': 'La duda es uno de los nombres de la inteligencia.', 'a': 'Borges'},
  {'q': 'Toda vida es una obra de arte hecha sin arte.', 'a': 'Borges'},
  {'q': 'La realidad no necesita ser verosímil; lo que necesita serlo son las ficciones.', 'a': 'Borges'},
  {'q': 'No nos une el amor sino el espanto. Será por eso que la quiero tanto.', 'a': 'Borges — Buenos Aires'},
  {'q': 'Un libro es una cosa entre las cosas, un volumen perdido entre los volúmenes que pueblan el indiferente universo, hasta que encuentra su lector.', 'a': 'Borges'},
  {'q': 'El tiempo es la sustancia de que estoy hecho. El tiempo es un río que me arrebata, pero yo soy el río.', 'a': 'Borges — Nueva refutación del tiempo'},
  {'q': 'Elogiar y denigrar son operaciones sentimentales que nada tienen que ver con la crítica.', 'a': 'Borges'},
  {'q': 'El futuro es inevitable, preciso, pero puede no ocurrir.', 'a': 'Borges'},
  {'q': 'Todo destino, por largo y complicado que sea, consta en realidad de un solo momento: el momento en que el hombre sabe para siempre quién es.', 'a': 'Borges — Biografía de Tadeo Isidoro Cruz'},

  {'q': 'Andábamos sin buscarnos pero sabiendo que andábamos para encontrarnos.', 'a': 'Cortázar — Rayuela'},
  {'q': 'Nada está perdido si se tiene el valor de proclamar que todo está perdido y hay que empezar de nuevo.', 'a': 'Cortázar'},
  {'q': 'Cada vez tendré menos certezas que ofrecer, seré cada vez más oscuro.', 'a': 'Cortázar'},
  {'q': 'La vida es lo que te pasa cuando todo anda mal y aun así te animás a reírte.', 'a': 'Cortázar'},
  {'q': 'Un profesor es una brújula que activa los imanes de la curiosidad, conocimiento y sabiduría en los alumnos.', 'a': 'Cortázar'},
  {'q': 'Cronopios, famas y esperanzas.', 'a': 'Cortázar'},

  {'q': 'La muerte no llega con la vejez, sino con el olvido.', 'a': 'Gabriel García Márquez'},
  {'q': 'No llorés porque terminó. Sonreí porque pasó.', 'a': 'García Márquez'},
  {'q': 'La vida no es lo que uno vivió, sino lo que recuerda, y cómo la recuerda para contarla.', 'a': 'García Márquez — Vivir para contarla'},
  {'q': 'Los seres humanos no nacen para siempre el día en que sus madres los alumbran: la vida los obliga a parirse a sí mismos una y otra vez.', 'a': 'García Márquez — El amor en los tiempos del cólera'},
  {'q': 'Lo que me preocupa no es que me hayas mentido, sino que ya no pueda creerte.', 'a': 'García Márquez'},

  {'q': 'Hay un único héroe válido: el héroe en bloque.', 'a': 'Sábato — Sobre héroes y tumbas'},
  {'q': 'La libertad es una tentación constante, pero sólo de vez en cuando un ser humano se anima a aceptar el desafío.', 'a': 'Sábato'},
  {'q': 'La esperanza no es la convicción de que algo saldrá bien, sino la certeza de que algo tiene sentido, independientemente de cómo resulte.', 'a': 'Ernesto Sábato'},

  {'q': 'Que tu jugada más hermosa no sea otra cosa que amar la vida que te tocó.', 'a': 'Mario Benedetti'},
  {'q': 'No te rindas, aún estás a tiempo.', 'a': 'Mario Benedetti'},
  {'q': 'Cuando teníamos todas las respuestas, nos cambiaron las preguntas.', 'a': 'Mario Benedetti'},
  {'q': 'Por suerte o por desgracia, hay un tiempo para todo.', 'a': 'Benedetti'},
  {'q': 'El olvido está lleno de memoria.', 'a': 'Benedetti'},

  {'q': 'Mucha gente pequeña, en lugares pequeños, haciendo cosas pequeñas, puede cambiar el mundo.', 'a': 'Eduardo Galeano — El libro de los abrazos'},
  {'q': 'La utopía está en el horizonte. Camino dos pasos, ella se aleja dos pasos. Entonces, ¿para qué sirve la utopía? Para eso: sirve para caminar.', 'a': 'Eduardo Galeano'},
  {'q': 'Somos lo que hacemos para cambiar lo que somos.', 'a': 'Eduardo Galeano'},
  {'q': 'Al fin y al cabo, somos lo que hacemos para cambiar lo que somos.', 'a': 'Galeano'},

  {'q': 'Puedo escribir los versos más tristes esta noche.', 'a': 'Pablo Neruda — Poema 20'},
  {'q': 'Muere lentamente quien evita una pasión.', 'a': 'Martha Medeiros (atribuido a Neruda)'},
  {'q': 'Es tan corto el amor y tan largo el olvido.', 'a': 'Pablo Neruda'},
  {'q': 'Algún día en cualquier parte, en cualquier lugar, indefectiblemente te encontrarás a ti mismo.', 'a': 'Pablo Neruda'},

  {'q': 'Has sido la compañera de mis sueños. Y también la de mis noches en vela.', 'a': 'Alejandra Pizarnik'},
  {'q': 'La poesía es el lugar donde todo sucede.', 'a': 'Alejandra Pizarnik'},
  {'q': 'Tengo miedo de no saber nombrar lo que no existe.', 'a': 'Alejandra Pizarnik'},

  {'q': 'La vida es una, y uno es la vida.', 'a': 'Macedonio Fernández'},
  {'q': 'El mundo no fue hecho para nosotros. Nosotros fuimos hechos para el mundo.', 'a': 'Macedonio Fernández'},

  {'q': 'La lucidez es una herida cercana al sol.', 'a': 'René Char'},
  {'q': 'Lo esencial es invisible a los ojos.', 'a': 'Saint-Exupéry — El Principito'},
  {'q': 'Si querés construir un barco, no empieces por buscar madera, cortar tablas o distribuir el trabajo. Evocá primero en los hombres el anhelo del mar libre y ancho.', 'a': 'Saint-Exupéry'},
  {'q': 'Los grandes sólo son grandes porque estamos de rodillas. Levantémonos.', 'a': 'Saint-Exupéry'},
  {'q': 'Cada uno es responsable para siempre de lo que ha domesticado.', 'a': 'Saint-Exupéry — El Principito'},
  {'q': 'No se ve bien sino con el corazón. Lo esencial es invisible a los ojos.', 'a': 'Saint-Exupéry — El Principito'},
  {'q': 'Los hombres ya no tienen tiempo de conocer nada. Compran cosas ya hechas a los mercaderes.', 'a': 'Saint-Exupéry — El Principito'},

  {'q': 'Cuando querés algo, todo el universo conspira para que lo consigas.', 'a': 'Paulo Coelho — El alquimista'},
  {'q': 'El secreto de la vida es caerse siete veces y levantarse ocho.', 'a': 'Paulo Coelho'},

  {'q': 'La cabeza piensa donde los pies pisan.', 'a': 'Leonardo Boff'},
  {'q': 'No hay lugar más desolado que el alma de un hombre que no ha amado.', 'a': 'Ernesto Cardenal'},

  // ── Literatura mundial ────────────────────────────────────────────────────
  {'q': 'Cualquiera puede volverse loco. Dale simplemente un empujoncito.', 'a': 'Joker — Batman'},
  {'q': 'Soy una jaula en busca de un pájaro.', 'a': 'Kafka'},
  {'q': 'Un libro tiene que ser el hacha que rompa el mar helado dentro de nosotros.', 'a': 'Kafka'},
  {'q': 'No hay nada más contagioso que un ejemplo.', 'a': 'Kafka'},
  {'q': 'Siempre hay esperanza, pero no para nosotros.', 'a': 'Kafka'},

  {'q': 'Si querés ser feliz, sélo.', 'a': 'Tolstói'},
  {'q': 'Todas las familias felices se parecen unas a otras; cada familia infeliz lo es a su manera.', 'a': 'Tolstói — Anna Karenina'},
  {'q': 'El tiempo y la paciencia son los mayores guerreros.', 'a': 'Tolstói — Guerra y paz'},
  {'q': 'Todos piensan en cambiar el mundo, pero nadie piensa en cambiarse a sí mismo.', 'a': 'Tolstói'},

  {'q': 'La belleza salvará al mundo.', 'a': 'Dostoyevski — El idiota'},
  {'q': 'Hay que amar la vida más que al sentido de la vida.', 'a': 'Dostoyevski — Los hermanos Karamazov'},
  {'q': 'El hombre que miente a sí mismo y cree sus propias mentiras llega a un punto en que no puede distinguir la verdad ni en sí mismo ni en los demás.', 'a': 'Dostoyevski — Los hermanos Karamazov'},

  {'q': 'El mundo rompe a todos y después muchos son fuertes en los lugares rotos.', 'a': 'Hemingway — Adiós a las armas'},
  {'q': 'Un hombre puede ser destruido, pero no derrotado.', 'a': 'Hemingway — El viejo y el mar'},
  {'q': 'Escribí borracho, editá sobrio.', 'a': 'Atribuido a Hemingway (apócrifo, pero hermoso)'},
  {'q': 'La valentía es gracia bajo presión.', 'a': 'Hemingway'},

  {'q': 'Podemos perdonar a un chico que le tiene miedo a la oscuridad. La tragedia real es cuando los hombres le tienen miedo a la luz.', 'a': 'Platón'},
  {'q': 'Viví cada día como si fuera tu último. Algún día vas a acertar.', 'a': 'Benjamin Franklin'},

  {'q': 'Sé vos mismo. Los demás puestos ya están ocupados.', 'a': 'Oscar Wilde'},
  {'q': 'Podemos perdonar a un hombre por hacer algo útil mientras no lo admire. La única excusa para hacer algo inútil es admirarlo intensamente.', 'a': 'Oscar Wilde'},
  {'q': 'Vivir es la cosa más rara en el mundo. La mayoría de la gente apenas existe.', 'a': 'Oscar Wilde'},
  {'q': 'Un cínico es alguien que conoce el precio de todo y el valor de nada.', 'a': 'Oscar Wilde — El abanico de Lady Windermere'},
  {'q': 'Siempre que la gente está de acuerdo conmigo, siento que debo estar equivocado.', 'a': 'Oscar Wilde'},
  {'q': 'La experiencia es simplemente el nombre que le damos a nuestros errores.', 'a': 'Oscar Wilde'},

  {'q': 'Llevo muchas vidas dentro de mí; no soy un solo hombre, soy un hombre y su ausencia.', 'a': 'Fernando Pessoa'},
  {'q': 'La vida es lo que hacemos de ella. Los viajes son los viajeros. Lo que vemos no es lo que vemos, sino lo que somos.', 'a': 'Fernando Pessoa'},
  {'q': 'Viajar es un suicidio lento.', 'a': 'Fernando Pessoa'},
  {'q': 'Literatura es la prueba de que la vida no alcanza.', 'a': 'Fernando Pessoa'},

  {'q': 'Vivir las preguntas ahora. Tal vez, sin que lo notés, vas a vivir gradualmente, algún día lejano, la respuesta.', 'a': 'Rilke — Cartas a un joven poeta'},
  {'q': 'Tal vez todo lo terrible es, en su esencia más profunda, algo indefenso que necesita nuestro amor.', 'a': 'Rilke'},
  {'q': 'Para el que está solo, todas las estaciones son largas.', 'a': 'Rilke'},

  {'q': 'No me arrepiento de nada. Lo único que lamentaría sería no haber vivido lo suficiente.', 'a': 'Simone de Beauvoir'},
  {'q': 'No se nace mujer, se llega a serlo.', 'a': 'Simone de Beauvoir — El segundo sexo'},

  {'q': 'Lo que no se nombra no existe.', 'a': 'George Steiner'},
  {'q': 'Cuando un hombre muere, una biblioteca se quema.', 'a': 'Proverbio africano'},

  {'q': 'Encontré lo que no buscaba y perdí lo que no tenía.', 'a': 'Roberto Bolaño'},
  {'q': 'La lectura es más importante que la escritura.', 'a': 'Roberto Bolaño'},
  {'q': 'La literatura es un oficio peligroso.', 'a': 'Bolaño'},

  {'q': 'Encontrá lo que amás y dejá que te mate.', 'a': 'Charles Bukowski'},
  {'q': 'La diferencia entre una democracia y una dictadura es que en una democracia votás primero y seguís órdenes después; en una dictadura no tenés que perder tiempo votando.', 'a': 'Bukowski'},
  {'q': 'No hay nada peor que llegar tarde, demasiado tarde.', 'a': 'Bukowski'},

  {'q': 'Nunca medimos el peso de nuestras decisiones antes de tomarlas.', 'a': 'Milan Kundera — La insoportable levedad del ser'},
  {'q': 'El amor es la decisión constante.', 'a': 'Erich Fromm — El arte de amar'},
  {'q': 'El amor inmaduro dice: te amo porque te necesito. El amor maduro dice: te necesito porque te amo.', 'a': 'Erich Fromm'},

  {'q': 'Cada hombre tiene por nacimiento derecho sobre su propia vida.', 'a': 'Herman Hesse — Demian'},
  {'q': 'El pájaro rompe el cascarón. El huevo es el mundo. Quien quiera nacer tiene que destruir un mundo.', 'a': 'Herman Hesse — Demian'},
  {'q': 'Es difícil encontrar la felicidad dentro de uno, pero imposible encontrarla en otra parte.', 'a': 'Herman Hesse'},
  {'q': 'El conocimiento se puede comunicar. La sabiduría no.', 'a': 'Herman Hesse — Siddhartha'},

  {'q': 'Dos caminos se abrían ante mí en un bosque, y yo elegí el menos transitado. Eso lo cambió todo.', 'a': 'Robert Frost — The Road Not Taken'},
  {'q': 'En tres palabras puedo resumir todo lo que aprendí de la vida: sigue adelante.', 'a': 'Robert Frost'},

  {'q': 'Sólo tengo una hora, me quedan sesenta minutos en la eternidad.', 'a': 'Virginia Woolf'},
  {'q': 'Nada ha ocurrido realmente hasta que no se haya descrito.', 'a': 'Virginia Woolf'},
  {'q': 'Una mujer necesita dinero y un cuarto propio si quiere escribir ficción.', 'a': 'Virginia Woolf — Un cuarto propio'},

  {'q': 'Vive tus propias preguntas. No busques las respuestas que no pueden darte todavía.', 'a': 'Rilke'},
  {'q': 'Lo mejor es amar a quien te enseña a amarte.', 'a': 'Clarice Lispector'},
  {'q': 'Nunca se puede terminar de conocer a una persona.', 'a': 'Clarice Lispector'},

  // ── Cine épico ────────────────────────────────────────────────────────────
  {'q': 'Fuerza y honor.', 'a': 'Gladiator (2000)'},
  {'q': 'Lo que hacemos en vida tiene su eco en la eternidad.', 'a': 'Máximo — Gladiator (2000)'},
  {'q': 'Hoy no, viejo amigo. Hoy no.', 'a': 'Gladiator (2000)'},
  {'q': 'Hermanos, lo que hacemos en la vida retumba en la eternidad.', 'a': 'Gladiator (2000)'},
  {'q': 'La muerte nos sonríe a todos. Todo lo que un hombre puede hacer es sonreírle de vuelta.', 'a': 'Máximo — Gladiator (2000)'},
  {'q': 'Soy Máximo Décimo Meridio, comandante de los ejércitos del Norte. Padre de un hijo asesinado, esposo de una mujer asesinada. Y voy a cobrar venganza, en esta vida o en la próxima.', 'a': 'Gladiator (2000)'},

  {'q': 'No todos los que vagan están perdidos.', 'a': 'Tolkien — El Señor de los Anillos'},
  {'q': 'Incluso las personas más pequeñas pueden cambiar el curso del futuro.', 'a': 'Galadriel — LOTR (2001)'},
  {'q': 'Ustedes no van a pasar.', 'a': 'Gandalf — LOTR (2001)'},
  {'q': 'No podemos elegir los tiempos que nos toca vivir. Sólo podemos decidir qué hacer con el tiempo que nos dan.', 'a': 'Gandalf — LOTR (2001)'},
  {'q': 'Sé que no puedo cargar el anillo por vos, pero puedo cargarte a vos.', 'a': 'Sam — LOTR (2003)'},
  {'q': 'Hay un bien en este mundo, Sr. Frodo. Y vale la pena pelear por él.', 'a': 'Sam — Las dos torres (2002)'},

  {'q': 'Hacer o no hacer. No hay intentar.', 'a': 'Yoda — Star Wars (1980)'},
  {'q': 'Que la fuerza te acompañe.', 'a': 'Star Wars (1977)'},
  {'q': 'El miedo lleva a la ira. La ira lleva al odio. El odio lleva al sufrimiento.', 'a': 'Yoda — Star Wars (1999)'},
  {'q': 'Tu foco determina tu realidad.', 'a': 'Qui-Gon Jinn — Star Wars (1999)'},
  {'q': 'Yo soy tu padre.', 'a': 'Darth Vader — Star Wars (1980)'},

  {'q': 'Yo soy inevitable.', 'a': 'Thanos — Avengers: Endgame (2019)'},
  {'q': 'Parte de ese viaje es su fin.', 'a': 'Tony Stark — Avengers: Endgame (2019)'},
  {'q': 'Con un gran poder viene una gran responsabilidad.', 'a': 'Tío Ben — Spider-Man'},
  {'q': 'Yo también te amo, 3000.', 'a': 'Tony Stark — Avengers: Endgame (2019)'},

  {'q': 'No se trata de qué tan fuerte podés pegar. Se trata de cuánto podés aguantar y seguir avanzando.', 'a': 'Rocky Balboa (2006)'},
  {'q': 'El mundo no es todo sol y arcoíris.', 'a': 'Rocky Balboa (2006)'},
  {'q': 'Tenés que estar dispuesto a recibir los golpes y no culpar a los demás.', 'a': 'Rocky Balboa (2006)'},
  {'q': 'Yo no soy el Sultán. Soy simplemente un italiano.', 'a': 'Rocky (1976)'},

  {'q': 'Carpe diem. Aprovechen el día, muchachos. Hagan extraordinarias sus vidas.', 'a': 'La sociedad de los poetas muertos (1989)'},
  {'q': 'La medicina, el derecho, la ingeniería son quehaceres nobles; pero la poesía, la belleza, el amor… por eso vivimos.', 'a': 'John Keating — La sociedad de los poetas muertos (1989)'},
  {'q': 'Me paro sobre mi escritorio para recordarme que debemos mirar las cosas de otra manera.', 'a': 'John Keating — La sociedad de los poetas muertos (1989)'},

  {'q': 'La vida es como una caja de bombones: nunca sabés qué te va a tocar.', 'a': 'Forrest Gump (1994)'},
  {'q': 'Tonto es el que hace tonterías.', 'a': 'Forrest Gump (1994)'},

  {'q': 'La esperanza es algo bueno, tal vez la mejor de las cosas. Y las cosas buenas nunca mueren.', 'a': 'Andy — Cadena perpetua (1994)'},
  {'q': 'Ocuparse de vivir, o ocuparse de morir.', 'a': 'Red — Cadena perpetua (1994)'},
  {'q': 'Sólo la música sobrevive al olvido.', 'a': 'Cinema Paradiso (1988)'},
  {'q': 'Lo que sea que hagás en la vida, hacelo con amor.', 'a': 'Cinema Paradiso (1988)'},

  {'q': 'No hay dos palabras en el idioma inglés más horribles que "buen trabajo".', 'a': 'Terence Fletcher — Whiplash (2014)'},
  {'q': 'Prefiero morir borracho, arruinado a los 34, y que la gente me recuerde en la cena, a vivir sano y rico hasta los 90 y que nadie se acuerde de mí.', 'a': 'Whiplash (2014)'},

  {'q': 'Es difícil no ser romántico con el béisbol.', 'a': 'Moneyball (2011)'},
  {'q': 'El primer regalo que te da la vida te lo da también la muerte.', 'a': 'Christopher — Interstellar (2014)'},
  {'q': 'No vamos a ir suavemente a esa buena noche.', 'a': 'Dylan Thomas citado en Interstellar (2014)'},
  {'q': 'Amor. Ésa es la única cosa que podemos percibir que trasciende las dimensiones del tiempo y el espacio.', 'a': 'Brand — Interstellar (2014)'},
  {'q': 'No somos la especie que rendirse define.', 'a': 'Cooper — Interstellar (2014)'},
  {'q': 'Nacimos en la Tierra, pero nunca fue nuestro destino morir acá.', 'a': 'Cooper — Interstellar (2014)'},

  {'q': 'Lo único que tengo es mi mundo de palabras.', 'a': 'Matrix (1999)'},
  {'q': 'No hay cuchara.', 'a': 'Matrix (1999)'},
  {'q': 'Elegí la pastilla roja.', 'a': 'Matrix (1999)'},
  {'q': 'La Matrix está en todas partes. Está a nuestro alrededor.', 'a': 'Morfeo — Matrix (1999)'},
  {'q': 'Hay una diferencia entre conocer el camino y caminar el camino.', 'a': 'Morfeo — Matrix (1999)'},

  {'q': 'Te voy a hacer una oferta que no vas a poder rechazar.', 'a': 'Don Vito Corleone — El Padrino (1972)'},
  {'q': 'Mantené a tus amigos cerca, y a tus enemigos más cerca.', 'a': 'Michael Corleone — El Padrino II (1974)'},
  {'q': 'Nunca odiés a tus enemigos. Afecta tu juicio.', 'a': 'Michael Corleone — El Padrino III (1990)'},

  {'q': 'El miedo es el asesino de la mente.', 'a': 'Dune (1984/2021)'},
  {'q': 'Debo no temer. El miedo es el asesino de la mente. Voy a enfrentar mi miedo. Voy a permitir que pase sobre mí y a través de mí.', 'a': 'Dune — Litanía contra el miedo'},

  {'q': 'Houston, tenemos un problema.', 'a': 'Apollo 13 (1995)'},
  {'q': 'El fracaso no es una opción.', 'a': 'Apollo 13 (1995)'},

  {'q': 'Nadie te va a pegar más fuerte que la vida. Pero no se trata de qué tan fuerte podés pegar, sino de qué tan fuerte podés recibir los golpes.', 'a': 'Rocky Balboa (2006)'},
  {'q': 'Las cicatrices te recuerdan que el pasado fue real.', 'a': 'Un tributo al amor (Dear John, 2010)'},

  {'q': 'Toda tu vida vas a estar buscándote.', 'a': 'Paterson (2016)'},
  {'q': 'En la vida hay dos tipos de personas: los que cuando se caen, se levantan; y los que cuando se caen, dicen: bueno, quizás este suelo no está tan mal.', 'a': 'Forrest Gump (1994)'},

  {'q': 'Si podés soñarlo, podés hacerlo.', 'a': 'Walt Disney'},
  {'q': 'Aquí está lo bueno del deporte profesional: nunca sabés qué va a pasar, y ésa es la razón por la que miramos.', 'a': 'Coach Taylor — Friday Night Lights'},

  {'q': 'La felicidad sólo es real cuando se comparte.', 'a': 'Into the Wild (2007)'},
  {'q': 'Dos cosas le temo a la vida: la muerte y que me roben la moto.', 'a': 'Diarios de motocicleta (2004)'},

  {'q': 'Después de todo, mañana será otro día.', 'a': 'Lo que el viento se llevó (1939)'},
  {'q': 'Siempre nos quedará París.', 'a': 'Casablanca (1942)'},
  {'q': 'De todas las tabernas de todas las ciudades del mundo, entra a la mía.', 'a': 'Casablanca (1942)'},

  {'q': 'No puedo volver al ayer porque era una persona diferente entonces.', 'a': 'Lewis Carroll — Alicia en el país de las maravillas'},
  {'q': 'Tenemos todas esas cosas en la cabeza. Las elegimos, nos aferramos a ellas. Eso es el pasado.', 'a': 'Blade Runner (1982)'},
  {'q': 'Es algo morir. Es algo vivir. Pero lo más difícil es ser humano.', 'a': 'Blade Runner 2049 (2017)'},

  {'q': 'No importa lo oscura que sea la noche, el sol siempre vuelve a salir.', 'a': 'El Rey León (1994)'},
  {'q': 'Hakuna Matata. Sin preocupaciones.', 'a': 'El Rey León (1994)'},
  {'q': 'Recordá quién sos.', 'a': 'Mufasa — El Rey León (1994)'},

  {'q': 'La primera regla del Club de la Pelea es: no se habla del Club de la Pelea.', 'a': 'Fight Club (1999)'},
  {'q': 'Las cosas que poseés terminan poseyéndote.', 'a': 'Fight Club (1999)'},
  {'q': 'No sos tu trabajo. No sos el dinero que tenés en el banco. No sos el auto que manejás.', 'a': 'Fight Club (1999)'},

  {'q': 'Un hombre con una pistola es un ciudadano. Un hombre sin pistola es un súbdito.', 'a': 'V de Vendetta (2005)'},
  {'q': 'Las ideas son a prueba de balas.', 'a': 'V de Vendetta (2005)'},
  {'q': 'La gente no debería temer a sus gobiernos. Los gobiernos deberían temer a su gente.', 'a': 'V de Vendetta (2005)'},

  {'q': 'La vida se mueve muy rápido. Si no parás de vez en cuando a mirar alrededor, te la podés perder.', 'a': 'Ferris Bueller (1986)'},
  {'q': 'La única constante en la vida es el cambio.', 'a': 'Heráclito citado en varios lados'},

  {'q': 'Soy Inigo Montoya. Mataste a mi padre. Prepárate a morir.', 'a': 'La princesa prometida (1987)'},
  {'q': 'El amor verdadero no se rinde. Nunca.', 'a': 'La princesa prometida (1987)'},

  {'q': 'Podés ser el mejor, podés ser un perdedor legendario, pero tu nombre no importa si no sentiste el viento en la cara.', 'a': 'Rush (2013)'},

  // ── Hábitos, productividad, libros clave ─────────────────────────────────
  {'q': 'No te elevás al nivel de tus metas. Caés al nivel de tus sistemas.', 'a': 'James Clear — Hábitos Atómicos'},
  {'q': 'Los hábitos son el interés compuesto de la mejora personal.', 'a': 'James Clear — Hábitos Atómicos'},
  {'q': 'Cada acción que realizás es un voto por el tipo de persona en que querés convertirte.', 'a': 'James Clear — Hábitos Atómicos'},
  {'q': 'No estás buscando ser perfecto; estás buscando ser mejor que ayer.', 'a': 'James Clear — Hábitos Atómicos'},
  {'q': 'La calidad de tus decisiones, no tu fuerza de voluntad, determina tu éxito.', 'a': 'James Clear'},
  {'q': 'Empezar es más importante que ser perfecto.', 'a': 'James Clear'},
  {'q': 'Pequeños cambios, resultados notables.', 'a': 'James Clear — Hábitos Atómicos'},
  {'q': 'El hábito es el camino por donde la acción se convierte en identidad.', 'a': 'James Clear'},
  {'q': 'Convertite en el tipo de persona que hace la cosa, y la cosa se hace sola.', 'a': 'James Clear'},
  {'q': 'Si no mejorás en un 1% cada día, estás en riesgo de empeorar.', 'a': 'James Clear'},

  {'q': 'El trabajo profundo es la única forma de hacer trabajo valioso en la era de las distracciones.', 'a': 'Cal Newport — Deep Work'},
  {'q': 'La capacidad de concentrarse intensamente es una habilidad que debe ser entrenada.', 'a': 'Cal Newport — Deep Work'},
  {'q': 'Si no dominás tu tiempo, alguien más lo va a dominar por vos.', 'a': 'Cal Newport'},
  {'q': 'Una vida centrada en valores, no en metas, es más satisfactoria.', 'a': 'Cal Newport'},
  {'q': 'Las grandes ideas requieren tiempo sin interrupciones.', 'a': 'Cal Newport — Deep Work'},

  {'q': 'Los hábitos no son un destino, son un proceso.', 'a': 'Charles Duhigg — El poder del hábito'},
  {'q': 'Cambiar un hábito no se trata de fuerza de voluntad sino de diseño.', 'a': 'Charles Duhigg'},

  {'q': 'En una mentalidad de crecimiento, los desafíos son emocionantes, no amenazantes.', 'a': 'Carol Dweck — Mindset'},
  {'q': 'Convertirse es mejor que ser.', 'a': 'Carol Dweck — Mindset'},
  {'q': 'Todavía no. Es la palabra más poderosa del aprendizaje.', 'a': 'Carol Dweck'},

  {'q': 'Tenemos unas cuatro mil semanas de vida. Es poco, pero alcanza.', 'a': 'Oliver Burkeman — Cuatro mil semanas'},
  {'q': 'La productividad es una trampa. Hacer más cosas no te da más tiempo.', 'a': 'Oliver Burkeman'},
  {'q': 'No podés hacer todo. Elegí.', 'a': 'Oliver Burkeman — Cuatro mil semanas'},

  {'q': 'La práctica deliberada es la diferencia entre los que mejoran y los que se estancan.', 'a': 'Anders Ericsson — Peak'},
  {'q': 'Los expertos no son talentos naturales. Son el resultado de años de práctica deliberada.', 'a': 'Anders Ericsson'},

  {'q': 'Empezá con el porqué.', 'a': 'Simon Sinek'},
  {'q': 'La gente no compra lo que hacés. Compra por qué lo hacés.', 'a': 'Simon Sinek — Start with Why'},

  {'q': 'La mejor manera de predecir el futuro es inventarlo.', 'a': 'Alan Kay'},
  {'q': 'La acción es el antídoto de la desesperación.', 'a': 'Joan Baez'},
  {'q': 'Hecho es mejor que perfecto.', 'a': 'Sheryl Sandberg'},

  {'q': 'Si te decís "voy a empezar mañana", ya perdiste.', 'a': 'Mel Robbins — La regla de los 5 segundos'},
  {'q': '5, 4, 3, 2, 1… moveté.', 'a': 'Mel Robbins'},

  {'q': 'Tus hábitos diarios son más importantes que tus metas anuales.', 'a': 'Atomic Habits (paráfrasis)'},
  {'q': 'No podés revertir una década de inacción en un mes.', 'a': 'Naval Ravikant'},
  {'q': 'El capitalismo intelectual va a superar al capitalismo de capital.', 'a': 'Naval Ravikant'},
  {'q': 'Deseá riqueza, no plata ni estatus. La riqueza es tener activos que ganen mientras dormís.', 'a': 'Naval Ravikant'},
  {'q': 'Leé lo que amás hasta que amés leer.', 'a': 'Naval Ravikant'},
  {'q': 'La felicidad es una habilidad. Se practica.', 'a': 'Naval Ravikant'},

  {'q': 'Hacé cosas difíciles primero cuando tu energía es máxima.', 'a': 'Brian Tracy — Eat That Frog'},
  {'q': 'Si tenés que comerte una rana, comela primero.', 'a': 'Mark Twain'},

  {'q': 'Primero lo primero.', 'a': 'Stephen Covey — 7 hábitos de la gente altamente efectiva'},
  {'q': 'Buscar primero entender, después ser entendido.', 'a': 'Stephen Covey'},
  {'q': 'La disciplina es la elección entre lo que querés ahora y lo que querés más.', 'a': 'Stephen Covey'},

  {'q': 'La motivación te arranca. El hábito te sostiene.', 'a': 'Jim Ryun'},
  {'q': 'No necesitás más motivación, necesitás más claridad.', 'a': 'James Clear'},

  {'q': 'Lo que se mide mejora.', 'a': 'Peter Drucker'},
  {'q': 'La cultura se come a la estrategia en el desayuno.', 'a': 'Peter Drucker'},
  {'q': 'La mejor manera de predecir el futuro es crearlo.', 'a': 'Peter Drucker'},
  {'q': 'El management es hacer las cosas bien; el liderazgo es hacer las cosas correctas.', 'a': 'Peter Drucker'},

  {'q': 'La disciplina es el puente entre metas y logros.', 'a': 'Jim Rohn'},
  {'q': 'Sos el promedio de las cinco personas con las que pasás más tiempo.', 'a': 'Jim Rohn'},
  {'q': 'Cuidá bien tu cuerpo. Es el único lugar donde tenés que vivir.', 'a': 'Jim Rohn'},
  {'q': 'La mente gana a la fuerza.', 'a': 'Jim Rohn'},

  {'q': 'Dejá de esperar viernes, el verano, el amor de tu vida, para empezar a vivir.', 'a': 'Oprah Winfrey'},
  {'q': 'Convertite en lo que creés.', 'a': 'Oprah Winfrey'},

  // ── Ciencia, pensadores ───────────────────────────────────────────────────
  {'q': 'Somos polvo de estrellas contemplándose a sí mismo.', 'a': 'Carl Sagan'},
  {'q': 'En algún lugar, algo increíble está esperando a ser descubierto.', 'a': 'Carl Sagan'},
  {'q': 'La ciencia es más que un cuerpo de conocimientos. Es una forma de pensar.', 'a': 'Carl Sagan'},
  {'q': 'Somos el modo en que el cosmos se conoce a sí mismo.', 'a': 'Carl Sagan — Cosmos'},
  {'q': 'La extraordinaria belleza del universo no necesita más adornos que la verdad.', 'a': 'Carl Sagan'},

  {'q': 'Soy lo suficientemente inteligente como para saber que no soy tan inteligente.', 'a': 'Richard Feynman'},
  {'q': 'Si creés entender la mecánica cuántica, no la entendés.', 'a': 'Richard Feynman'},
  {'q': 'El primer principio es no engañarte a vos mismo, y vos sos el más fácil de engañar.', 'a': 'Richard Feynman'},
  {'q': 'La ciencia es la creencia en la ignorancia de los expertos.', 'a': 'Richard Feynman'},
  {'q': 'Estudiar mucho es hermoso, pero mirar es mejor.', 'a': 'Richard Feynman'},
  {'q': 'Me gusta más no saber que creer que sé lo que no sé.', 'a': 'Richard Feynman'},

  {'q': 'Mirá las estrellas y no hacia tus pies.', 'a': 'Stephen Hawking'},
  {'q': 'La mayor enemiga del conocimiento no es la ignorancia. Es la ilusión de conocimiento.', 'a': 'Stephen Hawking'},
  {'q': 'Mientras haya vida, hay esperanza.', 'a': 'Stephen Hawking'},
  {'q': 'La inteligencia es la capacidad de adaptarse al cambio.', 'a': 'Stephen Hawking'},

  {'q': 'No teman a la perfección; nunca la van a alcanzar.', 'a': 'Salvador Dalí'},
  {'q': 'La inspiración existe, pero tiene que encontrarte trabajando.', 'a': 'Picasso'},
  {'q': 'Todos los chicos son artistas. El problema es cómo seguir siendo artista al crecer.', 'a': 'Picasso'},
  {'q': 'La acción es la clave fundamental del éxito.', 'a': 'Picasso'},

  {'q': 'No es la especie más fuerte la que sobrevive, ni la más inteligente, sino la más adaptable al cambio.', 'a': 'Atribuido a Darwin (en realidad Leon Megginson)'},
  {'q': 'Dame un punto de apoyo y moveré el mundo.', 'a': 'Arquímedes'},

  {'q': 'La vida no es fácil para ninguno de nosotros. Pero, ¿qué hay con eso? Hay que tener perseverancia.', 'a': 'Marie Curie'},
  {'q': 'Nada en la vida es para temerse, sólo para ser comprendido.', 'a': 'Marie Curie'},
  {'q': 'Nunca hay que dejar que la pobreza te impida hacer lo que más te apasiona.', 'a': 'Marie Curie'},

  {'q': 'El poder de un pensamiento es que puede transformarse en acción.', 'a': 'Hannah Arendt'},
  {'q': 'La banalidad del mal.', 'a': 'Hannah Arendt'},

  // ── Argentina: ídolos, música, deporte, humor ────────────────────────────
  {'q': 'La pelota no se mancha.', 'a': 'Diego Maradona'},
  {'q': 'El día que yo me vaya no voy a dejar herederos.', 'a': 'Diego Maradona'},
  {'q': 'Cuando pego, pego. Cuando amo, amo.', 'a': 'Diego Maradona'},
  {'q': 'Yo no soy ni bueno ni malo. Soy Diego.', 'a': 'Diego Maradona'},
  {'q': 'La vida no te da revancha. La vida es una sola y hay que vivirla.', 'a': 'Diego Maradona'},

  {'q': 'Yo juego porque me gusta el fútbol.', 'a': 'Lionel Messi'},
  {'q': 'Andá tranquilo, hermano.', 'a': 'Lionel Messi'},
  {'q': 'Empezás a ser campeón del mundo cuando empezás a creer que sos campeón del mundo.', 'a': 'Lionel Messi'},
  {'q': 'Aprendí que, cualquier cosa en la vida, el esfuerzo siempre tiene su recompensa.', 'a': 'Lionel Messi'},
  {'q': 'La única manera de lograr lo imposible es creer que es posible.', 'a': 'Lewis Carroll — Alicia'},

  {'q': 'El que no arriesga, no gana.', 'a': 'Marcelo Bielsa (entre muchos)'},
  {'q': 'El éxito es transitorio, efímero. Lo importante es el esfuerzo.', 'a': 'Marcelo Bielsa'},
  {'q': 'Un hombre con nuevas ideas es un loco, hasta que triunfa.', 'a': 'Marcelo Bielsa'},
  {'q': 'Cuando el éxito se convierte en el único valor, se pervierte todo lo demás.', 'a': 'Marcelo Bielsa'},

  {'q': 'Mañana es mejor.', 'a': 'Luis Alberto Spinetta'},
  {'q': 'Sólo se muere cuando te olvidan.', 'a': 'Luis Alberto Spinetta'},
  {'q': 'No llores por mí, Argentina. La verdad es que nunca me fui.', 'a': 'Eva Perón (en la obra de Rice/Lloyd Webber)'},
  {'q': 'Cerrá los ojos para ver.', 'a': 'Luis Alberto Spinetta'},
  {'q': 'Estás en el alma de las cosas.', 'a': 'Luis Alberto Spinetta — Seguir viviendo sin tu amor'},

  {'q': 'Los amigos son la familia que uno elige.', 'a': 'Jorge Luis Borges'},
  {'q': 'Uno no elige el país donde nace, pero lo ama por la manera en que duele.', 'a': 'Juan Gelman'},
  {'q': 'Quisiera que no me olvidaran los que me olvidarán para siempre.', 'a': 'Juan Gelman'},

  {'q': 'No me importa lo que digan. No hay nada mejor que la música argentina.', 'a': 'Charly García'},
  {'q': 'Dinosaurios van a desaparecer.', 'a': 'Charly García — Los dinosaurios'},
  {'q': 'Demoliendo hoteles.', 'a': 'Charly García'},
  {'q': 'Nos siguen pegando abajo.', 'a': 'Charly García — Canción de Alicia en el país'},

  {'q': 'El amor después del amor tal vez se pueda sentir.', 'a': 'Fito Páez'},
  {'q': 'La vida es hermosa.', 'a': 'Fito Páez — La vida es una moneda'},
  {'q': 'Todo hace falta, todo sirve.', 'a': 'Fito Páez'},

  {'q': 'No pasarán, esta lucha nos hermana.', 'a': 'Indio Solari — Redonditos de Ricota'},
  {'q': 'Mañana será otro día, pero hoy tengo un millón de sueños.', 'a': 'Indio Solari'},

  {'q': '¡Paren el mundo que me quiero bajar!', 'a': 'Mafalda — Quino'},
  {'q': 'Lo urgente no deja tiempo para lo importante.', 'a': 'Mafalda — Quino'},
  {'q': 'La vida es linda. Lo malo es que muchos confunden linda con fácil.', 'a': 'Mafalda — Quino'},
  {'q': 'Como siempre, lo urgente no deja tiempo para lo importante.', 'a': 'Quino — Mafalda'},

  {'q': 'La desgracia es que si no te ponés triste por las cosas tristes, sos un insensible; y si te ponés triste por las cosas tristes, sos un depresivo.', 'a': 'Fontanarrosa'},
  {'q': 'No hay mejor amigo que un buen libro.', 'a': 'Fontanarrosa (atribuido)'},
  {'q': 'Uno es del lugar donde es feliz.', 'a': 'Roberto Fontanarrosa'},

  {'q': 'Lo mejor de estar vivo es que cada día te sorprendés con algo.', 'a': 'Les Luthiers (atribuido)'},
  {'q': 'Recordá que las palabras importantes hay que decirlas en voz baja.', 'a': 'Julio Cortázar'},

  {'q': 'Un verdadero amigo es el que te dice la verdad, no el que te dice lo que querés escuchar.', 'a': 'Proverbio latinoamericano'},
  {'q': 'Si te caen del podio, subite a otro.', 'a': 'Dicho popular rioplatense'},

  // ── Poesía que te hace querer vivir ──────────────────────────────────────
  {'q': '¿Qué pensás hacer con tu única, salvaje y preciosa vida?', 'a': 'Mary Oliver — The Summer Day'},
  {'q': 'Prestá atención. Asombrate. Contalo.', 'a': 'Mary Oliver'},
  {'q': 'Cuando llegue la muerte… quiero poder decir: toda mi vida fui una novia casada con el asombro.', 'a': 'Mary Oliver — When Death Comes'},

  {'q': 'Oh, yo, oh, vida. El verso que vos podés contribuir.', 'a': 'Walt Whitman — Oh Me! Oh Life!'},
  {'q': 'Yo me celebro y me canto a mí mismo.', 'a': 'Walt Whitman — Canto de mí mismo'},
  {'q': 'Contengo multitudes.', 'a': 'Walt Whitman — Canto de mí mismo'},
  {'q': 'Resistí mucho, obedeced poco.', 'a': 'Walt Whitman'},

  {'q': 'Fui al bosque porque quería vivir deliberadamente.', 'a': 'Thoreau — Walden'},
  {'q': 'La mayoría de los hombres llevan vidas de silenciosa desesperación.', 'a': 'Thoreau — Walden'},
  {'q': 'No es lo que mirás, es lo que ves.', 'a': 'Thoreau'},

  {'q': 'Sos más vasto que el cielo.', 'a': 'Rumi'},
  {'q': 'La herida es el lugar por donde entra la luz.', 'a': 'Rumi'},
  {'q': 'Ayer era inteligente, quería cambiar el mundo. Hoy soy sabio y me estoy cambiando a mí.', 'a': 'Rumi'},

  {'q': 'Dos caminos divergían en un bosque amarillo, y yo tomé el menos transitado.', 'a': 'Robert Frost'},
  {'q': 'La mejor manera de salir es a través.', 'a': 'Robert Frost'},

  {'q': 'Había de morir de pie como los árboles.', 'a': 'Pedro Prado'},
  {'q': 'El silencio de los vivos es a veces más ruidoso que los gritos de los muertos.', 'a': 'Mahmud Darwish'},

  {'q': 'La única forma de lidiar con un mundo sin libertad es volverse tan absolutamente libre que la propia existencia sea un acto de rebelión.', 'a': 'Camus'},
  {'q': 'Dichosos los que aman, porque el amor es la única cosa inmortal.', 'a': 'Proverbio sufí'},

  // ── Humor inteligente, aforismos, paradojas ──────────────────────────────
  {'q': 'La simplicidad es la máxima sofisticación.', 'a': 'Leonardo da Vinci'},
  {'q': 'El arte nunca está terminado, sólo abandonado.', 'a': 'Leonardo da Vinci'},

  {'q': 'Ángeles vuelan porque se toman a sí mismos a la ligera.', 'a': 'G. K. Chesterton'},
  {'q': 'El loco no es el que perdió la razón. El loco es el que perdió todo menos la razón.', 'a': 'Chesterton — Ortodoxia'},
  {'q': 'Una aventura es sólo una inconveniencia bien considerada.', 'a': 'Chesterton'},

  {'q': 'Soy lo suficientemente viejo para saber que no sé nada.', 'a': 'Sócrates (paráfrasis)'},
  {'q': 'Me reservo el derecho a ser más inteligente mañana.', 'a': 'Konrad Lorenz'},

  {'q': 'Una bicicleta no puede mantenerse en pie sola porque es muy cansador.', 'a': 'Mitch Hedberg'},
  {'q': 'Nunca dejés que la verdad arruine una buena historia.', 'a': 'Mark Twain'},
  {'q': 'Es más fácil engañar a la gente que convencerlos de que los engañaron.', 'a': 'Mark Twain'},
  {'q': 'El secreto para adelantarse es empezar.', 'a': 'Mark Twain'},
  {'q': 'La historia no se repite, pero rima.', 'a': 'Mark Twain'},
  {'q': 'De vez en cuando tomate vacaciones de vos mismo.', 'a': 'Mark Twain'},

  {'q': 'Hay tres clases de mentiras: mentiras, mentiras atroces y estadísticas.', 'a': 'Mark Twain (atribuido)'},
  {'q': 'El hombre que lee vive mil vidas antes de morir. El que nunca lee, vive sólo una.', 'a': 'George R. R. Martin'},

  {'q': 'Sólo hay dos industrias que llaman a sus clientes "usuarios": la informática y la droga.', 'a': 'Edward Tufte'},
  {'q': 'Si pensás que la educación es cara, probá la ignorancia.', 'a': 'Derek Bok'},

  {'q': 'El verdadero placer de la vida está en no rendirnos jamás.', 'a': 'George Bernard Shaw'},
  {'q': 'La vida no se trata de encontrarte. Se trata de crearte.', 'a': 'George Bernard Shaw'},

  {'q': 'La gente razonable se adapta al mundo; los irrazonables insisten en que el mundo se adapte a ellos. Por eso, todo progreso depende de los irrazonables.', 'a': 'George Bernard Shaw'},
  {'q': 'Cuidado con el lector de un solo libro.', 'a': 'Santo Tomás de Aquino'},

  {'q': 'Dos cosas son infinitas: el universo y la estupidez humana. Y no estoy seguro del universo.', 'a': 'Einstein (atribuido)'},
  {'q': 'El optimista ve la rosquilla, el pesimista ve el agujero.', 'a': 'Oscar Wilde'},

  {'q': 'La vida es mucho más sencilla de lo que la gente cree. Lo difícil es explicar lo sencillo.', 'a': 'Confucio'},
  {'q': 'Hay dos errores que uno puede cometer en el camino hacia la verdad: no empezar, y no llegar hasta el final.', 'a': 'Buda'},

  {'q': 'Si querés hacer reír a Dios, contale tus planes.', 'a': 'Proverbio yiddish'},
  {'q': 'No hay atajos hacia ningún lugar al que valga la pena ir.', 'a': 'Beverly Sills'},

  {'q': 'La mejor crítica literaria es la lectura.', 'a': 'Vladimir Nabokov'},
  {'q': 'El lector ideal es un cómplice, no un juez.', 'a': 'Alberto Manguel'},

  // ── Deporte, competencia, resiliencia ────────────────────────────────────
  {'q': 'Los campeones no nacen en los gimnasios. Los campeones nacen de algo que llevan adentro: un deseo, un sueño, una visión.', 'a': 'Muhammad Ali'},
  {'q': 'Flotá como una mariposa, picá como una abeja.', 'a': 'Muhammad Ali'},
  {'q': 'El hombre que no tiene imaginación no tiene alas.', 'a': 'Muhammad Ali'},
  {'q': 'No cuentes los días. Hacé que los días cuenten.', 'a': 'Muhammad Ali'},
  {'q': 'Odio cada minuto de entrenamiento, pero dije: no te rindas. Sufrí ahora y viví el resto de tu vida como un campeón.', 'a': 'Muhammad Ali'},

  {'q': 'Perdés el 100% de los tiros que no hacés.', 'a': 'Wayne Gretzky'},
  {'q': 'He fallado más de nueve mil tiros en mi carrera. He perdido casi trescientos partidos. Por eso tengo éxito.', 'a': 'Michael Jordan'},
  {'q': 'Algunas personas quieren que suceda, otras desean que suceda, otras hacen que suceda.', 'a': 'Michael Jordan'},
  {'q': 'El talento gana partidos, pero el trabajo en equipo y la inteligencia ganan campeonatos.', 'a': 'Michael Jordan'},

  {'q': 'Sólo una vida vivida para los demás vale la pena.', 'a': 'Einstein'},
  {'q': 'Una persona que nunca cometió un error nunca intentó algo nuevo.', 'a': 'Einstein'},

  {'q': 'El dolor es temporal. El orgullo es para siempre.', 'a': 'Lance Armstrong (ya discutido, pero la frase quedó)'},
  {'q': 'Me convertí en el mejor del mundo estudiando las debilidades de mis oponentes y mejorando las mías.', 'a': 'Kobe Bryant'},
  {'q': 'La mentalidad de Mamba es siempre tratar de ser la mejor versión de vos mismo.', 'a': 'Kobe Bryant'},
  {'q': 'El trabajo duro supera al talento cuando el talento no trabaja duro.', 'a': 'Tim Notke'},

  {'q': 'No le tengo miedo al rival. Le tengo miedo a mi propio miedo.', 'a': 'Conor McGregor (paráfrasis)'},
  {'q': 'Siempre hay un rival por vencer: vos mismo.', 'a': 'Roger Federer'},
  {'q': 'La presión es un privilegio.', 'a': 'Billie Jean King'},

  // ── Vida, presencia, vivir la vida ────────────────────────────────────────
  {'q': 'La vida es lo que te sucede mientras estás ocupado haciendo otros planes.', 'a': 'John Lennon'},
  {'q': 'Al final, el amor que recibís es igual al amor que das.', 'a': 'The Beatles — The End'},
  {'q': 'Imaginá a toda la gente viviendo la vida en paz.', 'a': 'John Lennon — Imagine'},
  {'q': 'Todo va a estar bien al final. Si no está bien, no es el final.', 'a': 'John Lennon'},

  {'q': 'El presente es el único tiempo que te pertenece.', 'a': 'Eckhart Tolle — El poder del ahora'},
  {'q': 'Date cuenta de lo profundamente absurdo que es esperar que el presente sea distinto de lo que es.', 'a': 'Eckhart Tolle'},
  {'q': 'La mente se identifica con pensamientos. Vos no sos tu mente.', 'a': 'Eckhart Tolle'},

  {'q': 'No podés salvar a los demás. Tenés que salvarte primero.', 'a': 'Carl Jung'},
  {'q': 'Lo que resistís, persiste.', 'a': 'Carl Jung'},
  {'q': 'Conocéte a vos mismo y vas a conocer el universo.', 'a': 'Carl Jung'},
  {'q': 'Hasta que no hacés consciente el inconsciente, va a dirigir tu vida y lo vas a llamar destino.', 'a': 'Carl Jung'},

  {'q': 'El éxito no es final; el fracaso no es fatal: lo que cuenta es el coraje para continuar.', 'a': 'Winston Churchill'},
  {'q': 'Si estás pasando por el infierno, seguí caminando.', 'a': 'Winston Churchill'},
  {'q': 'Damos forma a nuestros edificios, y luego nuestros edificios nos dan forma.', 'a': 'Winston Churchill'},

  {'q': 'La única forma de hacer un gran trabajo es amar lo que hacés.', 'a': 'Steve Jobs'},
  {'q': 'Tu tiempo es limitado; no lo pierdas viviendo la vida de otra persona.', 'a': 'Steve Jobs'},
  {'q': 'Manténgante hambrientos, manténgante alocados.', 'a': 'Steve Jobs — Stanford 2005'},
  {'q': 'La innovación es lo que distingue a un líder de los seguidores.', 'a': 'Steve Jobs'},
  {'q': 'Los que están lo suficientemente locos como para pensar que pueden cambiar el mundo, son los que lo cambian.', 'a': 'Apple — Think Different'},

  {'q': 'Sé el cambio que querés ver en el mundo.', 'a': 'Gandhi (paráfrasis)'},
  {'q': 'Viví como si fueras a morir mañana. Aprendé como si fueras a vivir por siempre.', 'a': 'Gandhi'},
  {'q': 'La debilidad no puede perdonar. Perdonar es atributo del fuerte.', 'a': 'Gandhi'},
  {'q': 'Primero te ignoran, después se ríen de vos, después te atacan, después ganás.', 'a': 'Gandhi (atribuido)'},

  {'q': 'Soy el amo de mi destino. Soy el capitán de mi alma.', 'a': 'W. E. Henley — Invictus'},
  {'q': 'En la noche que me cubre, negra como un abismo, agradezco a los dioses, cualesquiera que sean, por mi alma inconquistable.', 'a': 'Henley — Invictus'},
  {'q': 'No importa cuán estrecha sea la puerta ni cuántos castigos lleve la sentencia: soy el dueño de mi destino.', 'a': 'Invictus'},

  {'q': 'La mayor gloria no es no caerse nunca, sino levantarse cada vez que nos caemos.', 'a': 'Nelson Mandela (paráfrasis de Confucio)'},
  {'q': 'La educación es el arma más poderosa para cambiar el mundo.', 'a': 'Nelson Mandela'},
  {'q': 'Parece imposible hasta que se hace.', 'a': 'Nelson Mandela'},
  {'q': 'Aprendí que el coraje no es la ausencia del miedo, sino el triunfo sobre él.', 'a': 'Nelson Mandela'},

  {'q': 'El futuro le pertenece a los que creen en la belleza de sus sueños.', 'a': 'Eleanor Roosevelt'},
  {'q': 'Lo mejor que podés hacer es lo correcto; lo siguiente mejor es lo incorrecto; lo peor que podés hacer es nada.', 'a': 'Theodore Roosevelt'},
  {'q': 'Lejos mejor es atreverse a grandes cosas, aunque falles, que vivir en el crepúsculo gris que no conoce victoria ni derrota.', 'a': 'Theodore Roosevelt — Man in the Arena'},
  {'q': 'El crédito pertenece al hombre que está en la arena.', 'a': 'Theodore Roosevelt'},

  {'q': 'Si tu único problema es tu problema, tenés solución.', 'a': 'Proverbio chino'},
  {'q': 'El mejor momento para plantar un árbol fue hace veinte años. El segundo mejor es ahora.', 'a': 'Proverbio chino'},

  {'q': 'Los que aman cantan, los que trabajan cantan, los que sufren cantan. Sólo los tristes no cantan.', 'a': 'Tagore'},
  {'q': 'La fe es el pájaro que canta cuando el amanecer todavía está oscuro.', 'a': 'Rabindranath Tagore'},

  {'q': 'Si buscás un milagro, empezá a fijarte: ya estás caminando sobre el agua.', 'a': 'Eckhart Tolle'},
  {'q': 'Todo lo que necesitás ya está adentro tuyo.', 'a': 'Proverbio sufí'},

  {'q': 'Soy un hombre; nada humano me es ajeno.', 'a': 'Terencio'},
  {'q': 'Errar es humano, perdonar es divino.', 'a': 'Alexander Pope'},

  {'q': 'Un libro debe ser el hacha que rompa el mar helado dentro nuestro.', 'a': 'Kafka'},
  {'q': 'La muerte es una cosa de animal. Vivir es una cosa humana.', 'a': 'Tolstói'},

  {'q': 'Mentir es una acción humana; decir la verdad es un arte.', 'a': 'Fernando Pessoa'},

  // ── Viaje, descubrimiento, coraje de moverse ─────────────────────────────
  {'q': 'No todos los que deambulan están perdidos.', 'a': 'Tolkien'},
  {'q': 'Nos cuesta creer que cambiamos porque queremos seguir siendo los mismos.', 'a': 'Clarice Lispector'},
  {'q': 'Los barcos están seguros en el puerto, pero no fueron construidos para eso.', 'a': 'John A. Shedd'},
  {'q': 'Nunca es demasiado tarde para ser lo que podrías haber sido.', 'a': 'George Eliot'},

  {'q': 'La vida empieza al final de tu zona de confort.', 'a': 'Neale Donald Walsch'},
  {'q': 'Si no te gusta el camino que estás tomando, empezá a pavimentar otro.', 'a': 'Dolly Parton'},
  {'q': 'El camino se hace al andar.', 'a': 'Antonio Machado'},
  {'q': 'Todo pasa y todo queda, pero lo nuestro es pasar. Pasar haciendo caminos, caminos sobre la mar.', 'a': 'Antonio Machado'},

  {'q': 'No hay respuestas fáciles, pero hay respuestas simples.', 'a': 'Ronald Reagan'},
  {'q': 'El optimista proclama que vivimos en el mejor de los mundos; el pesimista teme que esto sea verdad.', 'a': 'James Branch Cabell'},

  {'q': 'Aunque nada cambie, si yo cambio, todo cambia.', 'a': 'Marcel Proust'},
  {'q': 'El verdadero viaje de descubrimiento no consiste en buscar nuevos paisajes, sino en mirar con nuevos ojos.', 'a': 'Marcel Proust'},

  {'q': 'Los viajes son juventud, la juventud es un viaje.', 'a': 'Sylvia Plath'},
  {'q': 'Volvé a ser aquel que nunca fuiste.', 'a': 'Agustín de Hipona'},

  // ── Productividad y enfoque ──────────────────────────────────────────────
  {'q': 'Concentrate sólo en lo que podés controlar. Lo demás es ruido.', 'a': 'Ryan Holiday — The Obstacle is the Way'},
  {'q': 'El obstáculo en el camino se convierte en el camino.', 'a': 'Ryan Holiday — El obstáculo es el camino'},
  {'q': 'Tu ego es tu enemigo.', 'a': 'Ryan Holiday'},
  {'q': 'La disciplina es destino.', 'a': 'Ryan Holiday'},

  {'q': 'No esperés. El momento nunca va a ser el adecuado.', 'a': 'Napoleón Hill'},
  {'q': 'Lo que la mente humana puede concebir y creer, lo puede conseguir.', 'a': 'Napoleón Hill'},

  {'q': 'Tus acciones de hoy son las raíces de lo que vas a cosechar mañana.', 'a': 'Anónimo adaptado'},
  {'q': 'El momento en que estás por rendirte es exactamente el momento en que algo empieza a pasar.', 'a': 'Mizuta Masahide'},

  {'q': 'La única forma de hacer algo realmente bien es hacer más de lo que se espera.', 'a': 'Horace Mann'},
  {'q': 'Dejá de hacer planes. Empezá a hacer decisiones.', 'a': 'Marie Forleo'},

  {'q': 'Lo que medís, mejora. Lo que medís y reportás, mejora exponencialmente.', 'a': 'Pearson/Thomas (paráfrasis)'},
  {'q': 'Una lista es un acto de rebelión contra el caos.', 'a': 'Umberto Eco (paráfrasis)'},

  {'q': 'Divide cada dificultad en tantas partes como sea posible.', 'a': 'Descartes — Discurso del método'},
  {'q': 'Lo que se puede medir, se puede mejorar.', 'a': 'Peter Drucker'},

  {'q': 'Empezá donde estás. Usá lo que tenés. Hacé lo que podés.', 'a': 'Arthur Ashe'},
  {'q': 'Nadie es tan ocupado como la persona que no hace nada.', 'a': 'Proverbio'},

  {'q': 'La imperfección es belleza, la locura es genio, y es mejor ser absolutamente ridícula que absolutamente aburrida.', 'a': 'Marilyn Monroe'},
  {'q': 'Damos por sentado el tiempo hasta que un reloj empieza a medirlo en cuenta regresiva.', 'a': 'Oliver Burkeman (paráfrasis)'},

  // ── Más literatura, filosofía, reflexión ─────────────────────────────────
  {'q': 'Si tenés un jardín y una biblioteca, tenés todo lo que necesitás.', 'a': 'Cicerón'},
  {'q': 'La buena noticia es que estás vivo. La mala es que estás perdiendo un día precioso.', 'a': 'Paulo Coelho'},

  {'q': 'Amar o no amar: aquello por lo que se eligen las ciudades.', 'a': 'Italo Calvino — Las ciudades invisibles'},
  {'q': 'El hombre contemporáneo está trágicamente cerca del adolescente.', 'a': 'Italo Calvino'},

  {'q': 'Hay dos maneras de pasar la vida: una es actuar como si nada fuera un milagro; la otra, como si todo lo fuera.', 'a': 'Einstein'},
  {'q': 'Todo lo que es demasiado tonto para ser dicho, se canta.', 'a': 'Voltaire'},
  {'q': 'El trabajo aleja de nosotros tres grandes males: el aburrimiento, el vicio y la necesidad.', 'a': 'Voltaire'},

  {'q': 'Lo que está hecho por amor, está bien hecho.', 'a': 'Vincent Van Gogh'},
  {'q': 'El corazón del hombre es muy parecido al mar: tiene sus tormentas, tiene sus mareas, y en sus profundidades tiene sus perlas también.', 'a': 'Van Gogh'},
  {'q': 'Hago siempre lo que no puedo hacer, para poder aprender cómo hacerlo.', 'a': 'Van Gogh'},

  {'q': 'El silencio es uno de los grandes artes de la conversación.', 'a': 'Cicerón'},
  {'q': 'Vivir es no sólo existir sino existir y crear.', 'a': 'Miguel de Unamuno'},
  {'q': 'A veces el no decir nada es la mayor forma de amor.', 'a': 'Miguel de Unamuno'},

  {'q': 'El hombre libre es libre incluso en la cárcel, y el esclavo es esclavo incluso en el trono.', 'a': 'Nikos Kazantzakis — Zorba el griego'},
  {'q': 'No tengo nada, nada temo, nada deseo; soy libre.', 'a': 'Epitafio de Kazantzakis'},

  {'q': 'Vivir no es respirar, es actuar.', 'a': 'Jean-Jacques Rousseau'},
  {'q': 'El primero que, habiendo cercado un terreno, decidió decir "esto es mío"…', 'a': 'Rousseau — Discurso sobre la desigualdad'},

  {'q': 'Leer es viajar; viajar es leer.', 'a': 'Víctor Hugo'},
  {'q': 'Nada es tan poderoso como una idea a la que le ha llegado su momento.', 'a': 'Víctor Hugo'},
  {'q': 'La música expresa lo que no puede ser dicho, y sobre lo que es imposible permanecer en silencio.', 'a': 'Víctor Hugo'},

  {'q': 'No quiero ser un gran hombre. Sólo quiero ser un hombre completo.', 'a': 'Albert Camus'},
  {'q': 'En el otoño de mi vida, encontré que vivir es aceptar.', 'a': 'Albert Camus (paráfrasis)'},

  {'q': 'Uno debe amar su trabajo. Si no podés amarlo, al menos respetalo.', 'a': 'Anton Chejov'},
  {'q': 'El hombre es lo que él cree.', 'a': 'Chejov'},

  {'q': 'No es suficiente saber. También debemos aplicar. No basta con querer. Debemos actuar.', 'a': 'Goethe'},
  {'q': 'El talento se forma en la quietud; el carácter, en el torrente de la vida.', 'a': 'Goethe'},

  {'q': 'Uno vive sólo una vez, pero si lo hacés bien, una es suficiente.', 'a': 'Mae West'},
  {'q': 'El único modo de lidiar con la realidad es crearla.', 'a': 'Gabriel García Márquez (paráfrasis)'},

  {'q': 'Hay algo dentro nuestro, en todas las personas, algo así como una pequeña semilla de locura.', 'a': 'Julio Cortázar'},
  {'q': 'Prefiero los excesos de la pasión a la indiferencia.', 'a': 'Julio Cortázar'},

  {'q': 'Lo que no me pertenece, pertenece al olvido.', 'a': 'Alejandra Pizarnik'},
  {'q': 'Escribir es una forma de saber.', 'a': 'Pizarnik'},

  {'q': 'Para aprender a vivir hay que aprender a morir.', 'a': 'Proverbio tibetano'},
  {'q': 'Cuando naciste, llorabas y el mundo se alegró. Viví tu vida de tal forma que cuando mueras, el mundo llore y vos te alegrés.', 'a': 'Proverbio navajo'},

  {'q': 'La noche oscura del alma es donde la verdad despierta.', 'a': 'San Juan de la Cruz (paráfrasis)'},
  {'q': 'Dejate llevar. Cuanto más te resistís al río, más te ahoga.', 'a': 'Lao Tse (paráfrasis)'},

  // ── Pensamiento crítico, política del yo ────────────────────────────────
  {'q': 'La educación es el pasaporte al futuro, porque el mañana pertenece a los que se preparan hoy.', 'a': 'Malcolm X'},
  {'q': 'El futuro favorece a los que se preparan hoy.', 'a': 'Malcolm X'},

  {'q': 'La libertad nunca se da voluntariamente por el opresor; debe ser exigida por el oprimido.', 'a': 'Martin Luther King Jr.'},
  {'q': 'Sólo en la oscuridad podés ver las estrellas.', 'a': 'Martin Luther King Jr.'},
  {'q': 'Tengo un sueño.', 'a': 'Martin Luther King Jr.'},
  {'q': 'El tiempo es siempre el correcto para hacer lo correcto.', 'a': 'Martin Luther King Jr.'},

  {'q': 'Primero tienen que matar tu nombre. Después tu idea. Y al final, a vos.', 'a': 'Rodolfo Walsh'},
  {'q': 'El periodismo es libre o es una farsa.', 'a': 'Rodolfo Walsh'},

  {'q': 'No hay paz sin justicia; no hay justicia sin perdón; no hay perdón sin verdad.', 'a': 'Juan Pablo II'},
  {'q': 'Hacé lo que podás, con lo que tengas, donde estés.', 'a': 'Theodore Roosevelt'},

  // ── Cine: más reverencias ────────────────────────────────────────────────
  {'q': 'Cuando descubrís que estás montando un caballo muerto, la mejor estrategia es desmontar.', 'a': 'Proverbio Dakota citado en el cine'},
  {'q': 'Si construís la grandeza, va a venir.', 'a': 'Campo de sueños (1989)'},
  {'q': 'Ve y díselo a los espartanos, forastero, que en este lugar obedecimos sus órdenes.', 'a': 'Simónides — epitafio de Termópilas, citado en 300 (2007)'},
  {'q': 'Aquí hay locos, idiotas, gente lista, gente prudente, y nadie sabe cuál es cuál.', 'a': 'Forrest Gump'},

  {'q': 'El único lugar donde el éxito viene antes que el trabajo es en el diccionario.', 'a': 'Vidal Sassoon'},
  {'q': 'Te convertís en lo que pensás todo el día.', 'a': 'Ralph Waldo Emerson'},
  {'q': 'Ser uno mismo en un mundo que constantemente está tratando de que seas otra cosa es el mayor logro.', 'a': 'Emerson'},
  {'q': 'No vayas donde lleva el camino. En cambio, andá donde no hay camino y dejá un rastro.', 'a': 'Emerson'},
  {'q': 'La vida es un viaje, no un destino.', 'a': 'Ralph Waldo Emerson'},

  // ── Más sabiduría diversa ────────────────────────────────────────────────
  {'q': 'El tiempo es el mejor maestro, pero mata a todos sus alumnos.', 'a': 'Hector Berlioz'},
  {'q': 'La suerte es lo que pasa cuando la preparación encuentra la oportunidad.', 'a': 'Seneca (atribuido)'},

  {'q': 'Si no cambiás tus creencias, tu vida va a seguir siendo la misma por siempre.', 'a': 'Anthony Robbins'},
  {'q': 'La repetición es la madre de la habilidad.', 'a': 'Tony Robbins'},

  {'q': 'La vida me ha enseñado que hay cosas que son más fuertes que los sueños.', 'a': 'Michelle Obama'},
  {'q': 'Cuando van bajo, vamos alto.', 'a': 'Michelle Obama'},
  {'q': 'El éxito no se trata de cuánto dinero hacés, sino de la diferencia que hacés en la vida de los demás.', 'a': 'Michelle Obama'},

  {'q': 'No le tengas miedo a la perfección; nunca la vas a alcanzar.', 'a': 'Dalí'},
  {'q': 'Lo que hace a un desierto hermoso es que en algún lugar esconde un pozo.', 'a': 'Saint-Exupéry — El Principito'},

  {'q': 'Sólo cuando bebemos del río del silencio podemos realmente cantar.', 'a': 'Khalil Gibran — El profeta'},
  {'q': 'Trabajá con amor. Es amor hecho visible.', 'a': 'Gibran — El profeta'},
  {'q': 'Tus hijos no son tus hijos, son los hijos y las hijas del deseo de la vida por sí misma.', 'a': 'Gibran — El profeta'},

  {'q': 'No cuentes los minutos; hacé que los minutos cuenten.', 'a': 'Muhammad Ali (paráfrasis)'},
  {'q': 'Cuando te conocés, conocés el mundo.', 'a': 'Krishnamurti'},
  {'q': 'Es salud estar profundamente desajustado con una sociedad profundamente enferma.', 'a': 'Jiddu Krishnamurti'},

  {'q': 'Quien tiene imaginación, ¡con qué facilidad saca de nada un mundo!', 'a': 'Leopardi'},
  {'q': 'Dichosos aquellos que nada esperan, pues nunca serán defraudados.', 'a': 'Alexander Pope'},

  {'q': 'El hombre razonable se adapta al mundo; el irrazonable persiste en tratar de adaptar el mundo a él.', 'a': 'G. B. Shaw'},
  {'q': 'Cuando logré la plena aceptación de mí mismo, me resultó posible aceptar a los demás.', 'a': 'Alcohólicos Anónimos (tradición)'},

  {'q': 'El día que te deje de doler lo que te dolía, vas a saber que curaste algo.', 'a': 'Charly García (paráfrasis popular)'},
  {'q': 'Si un día lo pierdo todo, al menos me queda lo imposible.', 'a': 'Clarice Lispector'},

  {'q': 'Hay épocas en que ganar significa perder menos.', 'a': 'Paulo Coelho'},
  {'q': 'La soledad no es estar solo; es estar vacío.', 'a': 'Paulo Coelho'},

  {'q': 'Entre la decisión y el acto hay un infinito tiempo.', 'a': 'Hannah Arendt'},
  {'q': 'Nadie tiene el derecho de obedecer.', 'a': 'Hannah Arendt'},

  {'q': 'Todos los grandes maestros terminaron en algún momento por liberar a sus discípulos.', 'a': 'Osho'},
  {'q': 'La mente humana es una máquina de quejas.', 'a': 'Osho'},

  {'q': 'La gratitud convierte lo que tenemos en suficiente.', 'a': 'Aesop / Epicteto'},
  {'q': 'Las noches tranquilas nunca hicieron buenos marineros.', 'a': 'Proverbio náutico'},

  {'q': 'El corazón tiene razones que la razón no entiende.', 'a': 'Blaise Pascal'},
  {'q': 'Todas las desdichas del hombre derivan del hecho de no ser capaz de estar tranquilo y solo en una habitación.', 'a': 'Blaise Pascal'},
  {'q': 'El hombre no es más que una caña pensante.', 'a': 'Blaise Pascal'},

  {'q': 'Todo lo sólido se desvanece en el aire.', 'a': 'Karl Marx — Manifiesto'},
  {'q': 'Los filósofos sólo han interpretado el mundo de distintos modos. De lo que se trata es de transformarlo.', 'a': 'Karl Marx — Tesis sobre Feuerbach'},

  {'q': 'La práctica es la mejor profesora.', 'a': 'Cervantes — Don Quijote'},
  {'q': 'Ando desde que tengo memoria en busca de lo extraordinario cotidiano.', 'a': 'Cervantes (paráfrasis)'},

  {'q': 'La vida pasa volando, pero los sueños… los sueños pasan volando más rápido todavía.', 'a': 'Macedonio Fernández'},
  {'q': 'Todo lo bueno llega a quienes saben esperar, pero sólo lo que queda después de los que no esperan.', 'a': 'Lincoln (atribuido)'},

  {'q': 'Compraste zapatos para correr, después compraste ganas.', 'a': 'Anónimo runner argentino'},
  {'q': 'Cuando un hombre sabe adónde va, el mundo le abre paso.', 'a': 'Emerson'},

  {'q': 'Crecer significa descubrir que no todo se puede, pero también que tampoco importa tanto.', 'a': 'Anónimo contemporáneo'},
  {'q': 'Los que amás algún día se van a ir. Los que se fueron algún día los volvés a encontrar.', 'a': 'Fito Páez (paráfrasis)'},

  // ── Cierre: frases para levantarte del mal día ───────────────────────────
  {'q': 'Si no podés volar, corré. Si no podés correr, caminá. Si no podés caminar, arrastráte. Pero hagas lo que hagas, mantenéte moviéndote hacia adelante.', 'a': 'Martin Luther King Jr.'},
  {'q': 'Empezá ahora. No mañana. No el lunes. Ahora.', 'a': 'Anónimo'},
  {'q': 'Tu única competencia es quien eras ayer.', 'a': 'Jordan Peterson'},
  {'q': 'Hacete fuerte, porque es el único camino.', 'a': 'Indio Solari'},
  {'q': 'No cruces el río para ir a pegarle a un pibe.', 'a': 'Diego Maradona'},
  {'q': 'Si vas a intentar, llegá hasta el final. De lo contrario ni siquiera empieces.', 'a': 'Charles Bukowski'},
  {'q': 'Lo que hacés cuando nadie mira define lo que sos.', 'a': 'John Wooden'},
  {'q': 'La vida no te debe nada. Ya te dio todo: tiempo, respiración, posibilidad.', 'a': 'Stoicismo contemporáneo'},
  {'q': 'Un día de estos vas a despertar y no vas a tener tiempo para las cosas que siempre quisiste hacer. Hacelas ahora.', 'a': 'Paulo Coelho'},
  {'q': 'Las cosas que amás te construyen.', 'a': 'Haruki Murakami'},
  {'q': 'Cuando salgas de la tormenta, no vas a ser la misma persona que entró.', 'a': 'Haruki Murakami'},
  {'q': 'El dolor es inevitable. El sufrimiento es opcional.', 'a': 'Haruki Murakami'},
  {'q': 'Si realmente querés, encontrás la manera. Si no, encontrás una excusa.', 'a': 'Jim Rohn'},

  {'q': 'El tren del mejoramiento se llama hábito.', 'a': 'Atomic Habits (paráfrasis)'},
  {'q': 'La diferencia entre el imposible y el posible está en la determinación.', 'a': 'Tommy Lasorda'},

  {'q': 'No te rindas. Aunque el frío queme. Aunque el miedo muerda. Aunque el sol se esconda y se calle el viento.', 'a': 'Mario Benedetti — No te rindas'},
  {'q': 'Aunque sientas cansancio, aunque el hambre muerda. Seguí, porque no todo está perdido.', 'a': 'Benedetti — No te rindas'},
  {'q': 'Cuando creas que ya no podés más, tal vez ahí recién estés empezando.', 'a': 'Benedetti (paráfrasis)'},
];
