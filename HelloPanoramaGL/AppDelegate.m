/*
 * PanoramaGL library
 * Version 0.1
 * Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MapController.h"
#import "Model.h"
#import "PRProfileController.h"
#import "PRSceneController.h"
#import "PRService.h"
#import "PRToursController.h"

@interface AppDelegate ()

- (void)setupLoginController;
- (void)setupMainScreen;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSManagedObjectContext *context = [[PRService sharedService] context];

  Image *preview1 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  preview1.url = @"1_preview.jpg";
  preview1.path = @"1_preview.jpg";

  Image *pano1 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  pano1.url = @"1.jpg";
  pano1.path = @"1.jpg";

  Scene *scene1 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Scene class]) inManagedObjectContext:context];
  scene1.idProp = @(1);
  scene1.type = @(SceneTypeCylindrical);
  scene1.title = @"Холл";
  scene1.aboutDescription = @"Some description";
  scene1.images = [NSSet setWithObject:pano1];
  scene1.preview = preview1;

  Image *image11 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  image11.url = @"1_1.jpg";
  image11.path = @"1_1.jpg";

  InfoHotspot *hotspot11 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([InfoHotspot class]) inManagedObjectContext:context];
  hotspot11.idProp = @(11);
  hotspot11.image = image11;
  hotspot11.aboutDescription = @"Пискун Ю.А., Минск 1998г.";
  hotspot11.title = @"Соколиная охота";
  hotspot11.x = @(-125);
  hotspot11.y = @(-15);
  hotspot11.width = @(0.08);
  hotspot11.height = @(0.08);

  Image *image12 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  image12.url = @"1_2.jpg";
  image12.path = @"1_2.jpg";

  InfoHotspot *hotspot12 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([InfoHotspot class]) inManagedObjectContext:context];
  hotspot12.idProp = @(12);
  hotspot12.image = image12;
  hotspot12.aboutDescription = @"Пискун Ю.А., Минск 1997г.";
  hotspot12.title = @"Царевич";
  hotspot12.x = @(-34);
  hotspot12.y = @(-15);
  hotspot12.width = @(0.08);
  hotspot12.height = @(0.08);

  Image *image13 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  image13.url = @"1_3.jpg";
  image13.path = @"1_3.jpg";

  InfoHotspot *hotspot13 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([InfoHotspot class]) inManagedObjectContext:context];
  hotspot13.idProp = @(13);
  hotspot13.image = image13;
  hotspot13.aboutDescription = @"Пискун Ю.А., Минск 1997г.";
  hotspot13.title = @"Зося в древнем наряде";
  hotspot13.x = @(-25);
  hotspot13.y = @(-14);
  hotspot13.width = @(0.08);
  hotspot13.height = @(0.08);

  TransitionHotspot *hotspot1 =
      [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TransitionHotspot class]) inManagedObjectContext:context];
  hotspot1.idProp = @(1);
  hotspot1.title = @"Коридор";
  hotspot1.x = @(-180);
  hotspot1.y = @(-20);
  hotspot1.width = @(0.08);
  hotspot1.height = @(0.08);
  hotspot1.sceneId = @(2);

  scene1.hotspots = [NSSet setWithArray:@[ hotspot11, hotspot12, hotspot13, hotspot1 ]];

  Image *preview2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  preview2.url = @"2_preview.jpg";
  preview2.path = @"2_preview.jpg";

  Image *pano2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  pano2.url = @"2.jpg";
  pano2.path = @"2.jpg";

  Scene *scene2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Scene class]) inManagedObjectContext:context];
  scene2.idProp = @(2);
  scene2.type = @(SceneTypeCylindrical);
  scene2.title = @"Коридор";
  scene2.aboutDescription = @"Some description";
  scene2.images = [NSSet setWithObject:pano2];
  scene2.preview = preview2;

  TransitionHotspot *hotspot2 =
      [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([TransitionHotspot class]) inManagedObjectContext:context];
  hotspot2.idProp = @(2);
  hotspot2.title = @"Холл";
  hotspot2.x = @(-120);
  hotspot2.y = @(-10);
  hotspot2.width = @(0.08);
  hotspot2.height = @(0.08);
  hotspot2.sceneId = @(1);

  scene2.hotspots = [NSSet setWithObject:hotspot2];

  Location *location = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Location class]) inManagedObjectContext:context];
  location.latitude = @(53.676179);
  location.longitude = @(23.825370);

  Tour *tour = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tour class]) inManagedObjectContext:context];
  tour.idProp = @(1);
  tour.title = @"Новый Замок";
  tour.aboutDescription =
      @"Но́вый за́мок в Гро́дно — новый королевский дворец, построенный в Гродно, "
      @"напротив "
      @"старого "
      @"дворца "
      @"(Старый "
      @"замок), "
      @"в "
      @"1734—1751 "
      @"годах "
      @"во время правления польского короля и великого князя литовского Августа III как "
      @"летняя "
      @"резиденция "
      @"польских "
      @"королей "
      @"и "
      @"великих "
      @"князей литовских, по проекту Карла Фридриха Пёппельмана. Работы в замке "
      @"осуществляли "
      @"также "
      @"Иоганн "
      @"Фридрих "
      @"Кнёбель, Йохим Даниэль "
      @"Яух и до 1789 года Джузеппе де Сакко. Здесь проходили генеральные сеймы I "
      @"Речи Посполитой. В этом здании во время последнего "
      @"сейма Речи Посполитой "
      @"в 1793 году было "
      @"подписано соглашение "
      @"о разделе Речи "
      @"Посполитой с Россией "
      @"и Пруссией, а в 1795 "
      @"году "
      @"польский "
      @"король и "
      @"великий "
      @"князь "
      @"литовский "
      @"Станислав "
      @"Август "
      @"Понятовский "
      @"поставил "
      @"подпись под "
      @"актом "
      @"отречения."
      @"Король жил "
      @"в нём до "
      @"1797 года. В одной части дворца находились королевские покои, в а другой — помещения, предназначенные для заседаний сейма.Для "
      @"нужд сейма во дворе "
      @"также в 1726 году "
      @"было построено "
      @"специальное "
      @"здание.После 1750 "
      @"года построена "
      @"часовня, крытая "
      @"куполом, "
      @"частич"
      @"но "
      @"сохран"
      @"ились "
      @"также "
      @"въездн"
      @"ые "
      @"ворота"
      @".После"
      @" разде"
      @"лов "
      @"Речи "
      @"Поспол"
      @"итой "
      @"россий"
      @"ские "
      @"власти"
      @" устро"
      @"или "
      @"во "
      @"дворце"
      @" госпи"
      @"таль "
      @"и "
      @"казармы. В июле 1944 "
      @"года[источник не указан 288 "
      @"дней] здание сгорело в "
      @"результате военных "
      @"действий.Вновь отстроено к "
      @"1952 году "
      @"в "
      @"стиле "
      @"советск"
      @"ого "
      @"неоклас"
      @"сицизма"
      @".В нём "
      @"размеща"
      @"лся "
      @"областн"
      @"ой "
      @"комитет"
      @" КПСС."
      @"В "
      @"настоящ"
      @"ее "
      @"время "
      @"там "
      @"размеща"
      @"ется "
      @"часть "
      @"экспозиции "
      @"Гродненского "
      @"историко - "
      @"археологического "
      @"музея.В 1994 году "
      @"установлена "
      @"памятная доска в "
      @"честь национально "
      @"- "
      @"освободительного "
      @"восстания 1794 г.под руководством Т.Костюшко.";

  tour.scenes = [NSOrderedSet orderedSetWithObjects:scene1, scene2, nil];
  tour.preview = scene1.preview;
  tour.location = location;

  Image *preview3 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  preview3.url = @"3_preview.jpg";
  preview3.path = @"3_preview.jpg";

  Image *pano3 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  pano3.url = @"3.jpg";
  pano3.path = @"3.jpg";

  Scene *scene3 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Scene class]) inManagedObjectContext:context];
  scene3.idProp = @(3);
  scene3.type = @(SceneTypeSphere);
  scene3.title = @"Австрийская национальная библиотека. Интерьер";
  scene3.aboutDescription = @"Some description";
  scene3.images = [NSSet setWithObject:pano3];
  scene3.preview = preview3;

  Location *location2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Location class]) inManagedObjectContext:context];
  location2.latitude = @(48.2061623);
  location2.longitude = @(16.3666489);

  Tour *tour2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tour class]) inManagedObjectContext:context];
  tour2.idProp = @(2);
  tour2.title = @"Библиотека";
  tour2.aboutDescription =
      @"Австрийская национальная библиотека берёт своё начало от средневековой "
      @"императорской "
      @"библиотеки. "
      @"Герцог "
      @"Альбрехт "
      @"III "
      @"(1349—1395) "
      @"начал собирать книги, а также организовал переводы многих произведений с "
      @"латинского "
      @"языка "
      @"на "
      @"немецкий. "
      @"Всё "
      @"это "
      @"он хранил в "
      @"часовне Хофбурга. Император Фридрих III (1415—1493) дополнил коллекцию, привезя в "
      @"столицу "
      @"некоторые ценные книги. После него "
      @"большой вклад в развитие библиотеки сделал император "
      @"Максимилиан I (1459—1519), ставший обладателем "
      @"приданого первой жены, в том "
      @"числе книг из "
      @"Бургундии, которые он "
      @"перевёз в Хофбург. "
      @"Вторая жена "
      @"императора Бьянка "
      @"Мария Сфорца в "
      @"качестве приданого "
      @"привезла "
      @"книги из Италии. После смерти Максимилиана книги "
      @"хранились в Инсбруке.В это время библиотека пополнилась "
      @"научными "
      @"трудами "
      @"австрийских учёных, "
      @"глобусами, картами и "
      @"атласами, а фонды "
      @"значительно увеличены, "
      @"благодаря пожертвованиям "
      @"из личных "
      @"коллекций"
      @" "
      @"бога"
      @"тых "
      @"граж"
      @"дан."
      @"К "
      @"1575"
      @" год"
      @"у "
      @"колл"
      @"екци"
      @"я "
      @"уже "
      @"насч"
      @"итыв"
      @"ала "
      @"9 "
      @"тыс."
      @"экзе"
      @"мпля"
      @"ров,"
      @" и "
      @"для "
      @"уход"
      @"а "
      @"за "
      @"ней "
      @"был "
      @"наня"
      @"т "
      @"перв"
      @"ый "
      @"библиотекарь. С 1624 "
      @"года по распоряжению Фердинанда II государственная казна стала регулярно "
      @"выделять "
      @"средства "
      @"на "
      @"расширение библиотеки. В 1722 году "
      @"Карл VI приказал построить отдельное здание в Хофбурге "
      @"для императорской библиотеки.Коллекция продолжала "
      @"расширяться — принц "
      @"Евгений Савойский организовал "
      @"сбор средств, благодаря "
      @"которым удалось приобрести "
      @"около 15 тыс.томов во Франции "
      @"и Италии.В это же "
      @"время "
      @"была "
      @"организо"
      @"вана "
      @"картотек"
      @"а. "
      @"После "
      @"провозгл"
      @"ашения "
      @"Австрийс"
      @"кой "
      @"Республи"
      @"ки в "
      @"1920 "
      @"году "
      @"библиоте"
      @"ка была "
      @"переимен"
      @"ована в "
      @"Австрийскую национальную библиотеку.";
  tour2.scenes = [NSOrderedSet orderedSetWithObjects:scene3, nil];
  tour2.preview = scene3.preview;
  tour2.location = location2;

  Image *preview4 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  preview4.url = @"4_preview.jpg";
  preview4.path = @"4_preview.jpg";

  Image *pano4 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Image class]) inManagedObjectContext:context];
  pano4.url = @"4.jpg";
  pano4.path = @"4.jpg";

  Scene *scene4 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Scene class]) inManagedObjectContext:context];
  scene4.idProp = @(4);
  scene4.type = @(SceneTypeSphere);
  scene4.title = @"Херренхимзее Новый дворец";
  scene4.aboutDescription = @"Some description";
  scene4.images = [NSSet setWithObject:pano4];
  scene4.preview = preview4;

  Location *location3 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Location class]) inManagedObjectContext:context];
  location3.latitude = @(47.8604737);
  location3.longitude = @(12.4020819);

  Tour *tour3 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tour class]) inManagedObjectContext:context];
  tour3.idProp = @(3);
  tour3.title = @"Херренкимзе";
  tour3.aboutDescription =
      @"Загородная резиденция баварского короля Людвига II, раскинувшаяся на острове "
      @"Херрен "
      @"в "
      @"озере "
      @"Кимзе, "
      @"самом "
      @"крупном "
      @"озере "
      @"Баварии, "
      @"в 60 км к востоку от Мюнхена.Людвиг II выстроил Херренкимзе в подражание "
      @"Версалю, дабы принести дань уважения своему "
      @"кумиру "
      @"— "
      @"француз"
      @"скому "
      @"королю "
      @"Людовик"
      @"у "
      @"XIV."
      @"Ещё не "
      @"было "
      @"законче"
      @"но "
      @"строите"
      @"льство "
      @"Линдерх"
      @"офа, "
      @"когда "
      @"21 мая "
      @"1878 "
      @"года "
      @"заложил"
      @"и "
      @"первый "
      @"камень "
      @"дворца-"
      @"замка "
      @"Хе"
      @"рр"
      @"ен"
      @"ки"
      @"мз"
      @"е,"
      @" к"
      @"от"
      @"ор"
      @"ый"
      @" с"
      @"на"
      @"ча"
      @"ла"
      @" х"
      @"от"
      @"ел"
      @"и "
      @"по"
      @"ст"
      @"ро"
      @"ит"
      @"ь "
      @"в "
      @"до"
      @"ли"
      @"не"
      @" Г"
      @"ра"
      @"св"
      @"ан"
      @"гт"
      @"ал"
      @"ь,"
      @" н"
      @"аз"
      @"ва"
      @"в "
      @"ег"
      @"о "
      @"ан"
      @"аг"
      @"ра"
      @"мм"
      @"ой"
      @" «"
      @"Me"
      @"ic"
      @"os"
      @"t "
      @"Ettal». "
      @"Король очень страдал от того, что это "
      @"оказалось невозможным из-за грандиозных масштабов запланированной "
      @"постройки. Непомерная роскошь и расточительство, поражающие нас в "
      @"Линдерхофе, здесь "
      @"многократно превзойдены и в исполнении "
      @"рабочей силы, и в затратах финансовых "
      @"средств. Зеркальная галерея Херренкимзе — "
      @"подражание версальской Каждый, "
      @"кто "
      @"направляет"
      @"ся "
      @"сегодня "
      @"на "
      @"пароходике"
      @" от "
      @"пристани "
      @"Прин-ам-"
      @"Кимзее к "
      @"острову "
      @"Херренхимз"
      @"е, "
      @"восхищаетс"
      @"я "
      @"очаровател"
      @"ьной "
      @"природой "
      @"и широким "
      @"панорамным"
      @" "
      @"видо"
      @"м "
      @"на "
      @"Альп"
      @"ы. "
      @"Посе"
      @"тите"
      @"ль "
      @"може"
      @"т "
      @"заду"
      @"мать"
      @"ся "
      @"о "
      @"том,"
      @" что"
      @" рас"
      @"поло"
      @"жени"
      @"е "
      @"госу"
      @"дарс"
      @"твен"
      @"ного"
      @" кор"
      @"олев"
      @"ског"
      @"о "
      @"замк"
      @"а "
      @"на "
      @"отда"
      @"лённ"
      @"ом "
      @"остр"
      @"ове "
      @"неск"
      @"ольк"
      @"о "
      @"необ"
      @"ычно"
      @". "
      @"Но "
      @"если вспомнить "
      @"расположенный на скале "
      @"замок Нойшванштайн, "
      @"скрытый в высокогорной "
      @"долине замок Линдерхоф "
      @"или высотную резиденцию "
      @"Шахен, "
      @"расположенну"
      @"ю "
      @"выше "
      @"зоны "
      @"расти"
      @"тельн"
      @"ости,"
      @" то "
      @"выбор"
      @" для "
      @"постр"
      @"ойки "
      @"следу"
      @"ющего"
      @" замк"
      @"а-"
      @"остро"
      @"ва, "
      @"до "
      @"котор"
      @"ого "
      @"можно"
      @" добр"
      @"аться"
      @" толь"
      @"ко "
      @"водны"
      @"м "
      @"путём"
      @", "
      @"уже "
      @"никого не "
      @"удивит. "
      @"Корол"
      @"ь "
      @"Людви"
      @"г "
      @"искал"
      @" один"
      @"очест"
      @"ва, "
      @"и "
      @"здесь"
      @" оно "
      @"было "
      @"ему "
      @"гаран"
      @"тиров"
      @"ано, "
      @"как "
      @"нигде"
      @". "
      @"Можно"
      @" не "
      @"сомне"
      @"ватьс"
      @"я, "
      @"что "
      @"такой выбор короля Людвига обусловлен более "
      @"чем тысячелетней монастырской традицией острова, которая "
      @"не прерывалась вплоть до секуляризации. Здесь, на этой "
      @"священной земле, он мог воздвигнуть "
      @"культовый храм в "
      @"память короля "
      @"Людовика XIV "
      @"Французского. "
      @"После того, как "
      @"остров в 1803 "
      @"году был "
      @"конфискован у "
      @"церкви и сменил "
      @"несколько "
      @"владельцев, "
      @"Л"
      @"ю"
      @"д"
      @"в"
      @"и"
      @"г"
      @" "
      @"к"
      @"у"
      @"п"
      @"и"
      @"л"
      @" "
      @"е"
      @"г"
      @"о"
      @" "
      @"в"
      @" "
      @"с"
      @"е"
      @"н"
      @"т"
      @"я"
      @"б"
      @"р"
      @"е"
      @" "
      @"1"
      @"8"
      @"7"
      @"3"
      @" "
      @"г"
      @"о"
      @"д"
      @"а"
      @"."
      @" "
      @"Г"
      @"о"
      @"д"
      @" "
      @"с"
      @"п"
      @"у"
      @"с"
      @"т"
      @"я"
      @","
      @" "
      @"в"
      @"о"
      @" "
      @"в"
      @"р"
      @"е"
      @"м"
      @"я"
      @" "
      @"с"
      @"в"
      @"о"
      @"е"
      @"й"
      @" "
      @"п"
      @"о"
      @"е"
      @"з"
      @"д"
      @"к"
      @"и"
      @" "
      @"в"
      @"о"
      @" "
      @"Ф"
      @"р"
      @"а"
      @"н"
      @"ц"
      @"и"
      @"ю"
      @","
      @" "
      @"о"
      @"н"
      @" "
      @"с"
      @"а"
      @"м"
      @"ы"
      @"м"
      @" "
      @"т"
      @"щ"
      @"а"
      @"т"
      @"е"
      @"л"
      @"ь"
      @"н"
      @"ы"
      @"м"
      @" "
      @"о"
      @"б"
      @"р"
      @"а"
      @"з"
      @"о"
      @"м"
      @" "
      @"о"
      @"с"
      @"м"
      @"о"
      @"т"
      @"р"
      @"е"
      @"л"
      @" "
      @"В"
      @"е"
      @"р"
      @"с"
      @"а"
      @"л"
      @"ь"
      @"."
      @" "
      @"И"
      @" "
      @"р"
      @"а"
      @"з"
      @"р"
      @"а"
      @"б"
      @"о"
      @"т"
      @"к"
      @"а"
      @" "
      @"проекта, и "
      @"строительство "
      @"проходили "
      @"стремительными "
      @"темпами. Первый визит "
      @"короля в новый замок "
      @"состоялся уже в 1881 "
      @"году. На момент "
      @"смерти короля 50 "
      @"из "
      @"70 комнат дворца-замка ещё стояли без обстановки. Во время строительства Людвиг писал архитекторам: «Не копировать, но цитировать в духе Людовика "
      @"XIV».";
  tour3.scenes = [NSOrderedSet orderedSetWithObjects:scene4, nil];
  tour3.preview = scene4.preview;
  tour3.location = location3;

  [[PRService sharedService] saveContext];
  if (self.window == nil) {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    [imageView setImage:[UIImage imageNamed:@"mainBkg.png"]];
    [self.window makeKeyAndVisible];
  }
  [self setupLoginController];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming
   phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to
   its current state in case it is terminated later.
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally
   refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

#pragma mark - Public Methods
- (void)logout {
  [self setupLoginController];
}

#pragma mark - Private Methods
- (void)setupLoginController {
  __weak typeof(self) weakSelf = self;
  LoginViewController *loginVC = [[LoginViewController alloc] init];
  loginVC.onSkipButtonTapBlock = ^{
    [weakSelf setupMainScreen];
    [PRService sharedService];
  };

  [self.window setRootViewController:loginVC];
}

- (void)setupMainScreen {
  UITabBarController *tabBarController = [[UITabBarController alloc] init];

  PRToursController *toursVC = [PRToursController new];
  toursVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Туры" image:[UIImage imageNamed:@"toursIcon.png"] tag:1];
  MapController *mapVC = [MapController new];
  mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта" image:[UIImage imageNamed:@"mapIcon.png"] tag:2];
  PRProfileController *profileVC = [PRProfileController new];
  profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Профиль" image:[UIImage imageNamed:@"profileIcon.png"] tag:3];
  [tabBarController setViewControllers:@[ toursVC, mapVC, profileVC ]];
  [self.window setRootViewController:tabBarController];
}

@end
