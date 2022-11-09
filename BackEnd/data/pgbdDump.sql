-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: k7e203.p.ssafy.io    Database: dokcho
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `boss`
--

DROP TABLE IF EXISTS `boss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `boss` (
  `mission_id` bigint NOT NULL,
  `attack` int DEFAULT NULL,
  `hp` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mission_id`),
  CONSTRAINT `FK9xqlhauj24d0sa9t3308y36rp` FOREIGN KEY (`mission_id`) REFERENCES `mission` (`mission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boss`
--

LOCK TABLES `boss` WRITE;
/*!40000 ALTER TABLE `boss` DISABLE KEYS */;
INSERT INTO `boss` VALUES (1,80,400,'다람쥐'),(2,110,600,'사슴'),(3,140,700,'학'),(4,170,800,'여우'),(5,200,900,'개'),(6,230,1000,'고양이'),(7,260,1100,'소'),(8,300,1500,'호랑이');
/*!40000 ALTER TABLE `boss` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `item_id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (1,'고조선의 청동 검','청동 검','STORY_ITEM'),(2,'고구려군의 깃발','삼족오의 깃발','STORY_ITEM'),(3,'신라의 천문대','첨성대','STORY_ITEM'),(4,'고려의 신비로운 도자기','고려청자','STORY_ITEM'),(5,'조선의 해시계','앙부일구','STORY_ITEM'),(6,'이순신의 일기','난중일기','STORY_ITEM'),(7,'대한민국의 국기','태극기','STORY_ITEM'),(8,'','','STORY_ITEM'),(11,'고조선의 청동 거울','청동 거울','STORY_ITEM'),(12,'광개토대왕의 업적을 기리기 위해 세워진 비','광개토대왕릉비','STORY_ITEM'),(13,'아름다운 신라의 금관','금관','STORY_ITEM'),(14,'외적을 물리치기 위해 만들어진 고려의 대장경','팔만대장경','STORY_ITEM'),(15,'백성을 가르치는 바른 소리','훈민정음','STORY_ITEM'),(16,'임진왜란에서 활약한 조선 수군의 군함','거북선','STORY_ITEM'),(17,'대한민국의 국기','태극기','STORY_ITEM'),(18,'허준이 편찬한 의학 서적','동의보감','STORY_ITEM'),(21,'풀깨비의 체력을 50 회복 시켜준다.','회복 물약(소)','USE_ITEM'),(22,'상대방의 공격을 1회 무효화 한다.','공격 무효화','USE_ITEM'),(23,'공격을 2번 연속 사용한다.','더블 어택','USE_ITEM'),(24,'아이템을 사용한 배틀에서 공격력을 20% 증가 시켜준다.','공격력 증가','USE_ITEM'),(25,'전체 체력의 80%를 희생하여 상대방을 10%확률로 즉사시키는 주문을 발동한다.','희생','USE_ITEM'),(28,'죽음에 이르는 그 어떤 공격이라도 체력 1을 보존하게 한다.','생존','USE_ITEM'),(29,'사용한 공격의 데미지의 30%를 체력으로 전환한다.','흡혈','USE_ITEM'),(30,'아이템을 사용한 턴에 한하여 상대방의 공격력을 30 감소 시켜준다.','무력화','USE_ITEM'),(31,'풀깨비의 체력을 200회복 시켜 준다.','회복 물약(중)','USE_ITEM'),(32,'풀깨비의 체력을 500회복 시켜 준다.','회복 물약(대)','USE_ITEM'),(33,'상대방에게 30의 피해를 주고 10턴 동안 상대방 턴이 시작할 때 마다 10 데미지를 준다.','독극물','USE_ITEM'),(34,'상대방를 기절시켜 행동하지 못하게 만든다.','기절','USE_ITEM'),(35,'사용한 배틀에서 방어력 30%를 증가시킨다.','방어력 증가','USE_ITEM');
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mission`
--

DROP TABLE IF EXISTS `mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mission` (
  `mission_id` bigint NOT NULL AUTO_INCREMENT,
  `characters` varchar(255) DEFAULT NULL,
  `exp` int DEFAULT NULL,
  `item` bigint DEFAULT NULL,
  `line1` varchar(1000) DEFAULT NULL,
  `line2` varchar(1000) DEFAULT NULL,
  `line3` varchar(1000) DEFAULT NULL,
  `line4` varchar(1000) DEFAULT NULL,
  `relic` bigint DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `line0` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`mission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mission`
--

LOCK TABLES `mission` WRITE;
/*!40000 ALTER TABLE `mission` DISABLE KEYS */;
INSERT INTO `mission` VALUES (1,'단군',100,1,'거기 아해야, 잠시 날 도와주지 않으련?\\t나는 고조선을 세운 단군이라고 한단다.\\t며칠 전에 우리 고조선의 보물 중 하나인 청동 거울을 다람쥐가 훔쳐가 버렸단다.\\t날 좀 도와주지 않겠니?\\t고맙구나.','우헤헹! 나는 호랑이 님의 부하 다람쥐야!\\t청동 거울의 신비한 빛은 우리 호랑이 님께 어울리지!\\t돌려 달라고? 너 나보다 고조선에 대해 잘 알아?','…생각보다 잘 아네?\\t그래도 안 돌려 줄 거야. 너 나보다 잘 싸워?','청동 거울을 찾아주었구나. 고맙네.\\t이 청동 거울은 청동 방울, 청동 검과 함께 하늘이 우리에게 내려준 3가지 보물 중 하나이지.\\t자네에게는 이 청동 검을 주겠네.\\t호랑이를 찾는다고 했지? 미안하네만 호랑이는 우리 어머니와 알던 사이이고 난 소식을 못 들은 지 좀 됐어.\\t그러고 보니 고구려에서 호랑이에 현상금을 걸었다던데… 한번 찾아가 보는 게 어떤가?',11,'단군 할아버지는 예전에 호랑이와 알던 사이라고 한다. 단군 할아버지를 찾아가 단서를 찾아보자.','이 곳에 터를 잡으면 좋은 나라가 될게야.'),(2,'장수왕',100,2,'누구냐!!!!!\\t아, 허준 선생의 제자로구나. 자네 사슴을 보지 못했나?\\t호랑이의 부하인 사슴 녀석이 선왕의 업적을 기리는 능비를 뽑아가 버렸네. 용서할 수 없어!\\t자네도 호랑이를 찾고 있다고? 그럼 나를 좀 도와주게.','하하하! 나는 호랑이 님을 모시는 사슴이다!\\t이 능비는 정복왕 광개토대왕의 것이라며? 그 업적은 이제 호랑이 님의 것이다!!\\t나보다 삼국 시대에 대해 모르는 녀석에게는 돌려줄 수 없지!','…흠 그래도 쉽게 돌려줄 순 없지!\\t내 뿔은 장식이 아니라고!!','오오! 능비를 되찾았군!!\\t훌륭하다! 내 상을 내리도록 하지!!\\t이것은 우리 고구려 군의 삼족오 깃발일세.\\t호랑이를 찾고 있다고 했지.. 듣자 하니 신라에서도 문제가 있었다더군. 한번 찾아가 보는 게 어떤가?',12,'고구려가 호랑이에게 현상금을 걸었다고 한다. 장수왕을 찾아가 단서를 찾아보자.','나는 오래 살아서 장수왕이라네.'),(3,'선덕여왕',150,3,'어서오게. 자네가 고구려를 도와줬다지?\\t마침 우리도 호랑이 때문에 속을 썩이고 있던 참이었네.\\t호랑이의 부하 왜가리가 우리 신라의 금관을 물고 날아가 버렸어.\\t혼란을 틈타 비담이 난을 일으키는 바람에 왜가리를 쫓을 수도 없는 참이었지… 자네가 좀 도와줄 수 있겠나?','까아악!! 나는 호랑이 님의 수하 왜가리!!\\t이 아름다운 금관은 하늘을 지배하는 나에게 어울리지~ 물론 호랑이 님께 바칠 거지만!!\\t나보다 통일 신라 시대에 대해 잘 안다면 금관이 어울릴지도?','제법인데?\\t하지만 금관이 어울린다 해서 돌려 준다는 건 아니라고?','금관을 찾아왔나? 고맙네. 한시름 놓을 수 있겠군.\\t보답으로 이걸 주지. 이번에 짓기로 한 첨성대의 모형이네.\\t그러고 보니 지난 밤 고려의 군사가 이동하는 걸 봤는데… 호랑이와 관련이 있을 지도 모르겠군. 한번 찾아가 보는게 어떤가?',13,'신라가 호랑이 때문에 곤경에 처했다고 한다. 선덕여왕을 찾아가 단서를 찾아보자.','내가 바로 이 땅 최초의 여왕이다.'),(4,'공민왕',150,4,'신돈이냐? 아니군… 자네는 누구냐?\\t호랑이? 그 놈의 부하가 어제 팔만대장경을 훔쳐갔지.\\t팔만대장경은 자주 정신의 상징과도 같은 물건인데 어찌…\\t그래, 팔만대장경을 찾아주면 호랑이에 대한 정보를 주마.\\t어제 나타난 놈의 부하는 여우다.','히히히! 나는 호랑이 님의 오른팔 여우란다!\\t내 변신 능력과 이 팔만대장경의 가르침만 있으면 우리 호랑이 님을 부처로 만들 수 있겠지!\\t너 고려 시대에 대해 좀 알고 있니?','보기보다 똑똑하구나!\\t그럼 보기보다 강한지 확인해볼까?','팔만대장경을 찾아왔다고? 아주 잘했다!!\\t보답으로 이 고려 청자를 주마. 아름답지?\\t그리고 이건 여우가 떨어트린 쪽지다. 자네라면 읽을 수 있겠지.',14,'지난 밤, 고려의 군사가 대규모로 이동하는 걸 목격했다고 한다. 공민왕을 찾아가 단서를 찾아보자.','이 나라엔 개혁이 필요하다!'),(5,'세종대왕',200,5,'오 허준 선생의 제자 아닌가? 선생은 잘 계신가?\\t그렇군… 실은 나도 얼마 전에 훈민정음을 빼앗겨 버렸네만…\\t자네가 되찾아 주겠다고? 고맙구나!\\t훈민정음은 감투를 쓴 개가 훔쳐가 버렸다고 하네. 부디 찾아주게.','멍멍!\\t멍멍멍멍!','멍멍멍멍!\\t….멍!','찾아왔는가? 고맙네!\\t아마 사람 말을 배우고 싶었던 게지… 가엾은 것들\\t그래 상으로 이 앙부일구를 주지.\\t이게 있으면 해가 떠있는 동안에는 시간을 알 수 있을걸세.\\t듣자 하니 남쪽 바다에서 시끄러운 소동이 있었다던데. 자네가 찾고 있는 호랑이와 관련이 있지 않겠나?',15,'한글로 작성된 동물의 쪽지를 발견했다. 세종대왕을 찾아가 단서를 찾아보자.','조선의 궁궐에 당도한 것을 환영하오, 낯선이여. '),(6,'이순신',200,6,'그래, 무슨 일인가?\\t…그렇군. 우리 군에서도 며칠 전 호랑이의 부하인 고양이가 사건을 일으켰지.\\t거북선 한 척을 훔쳐 가버렸네. 안에 무기로 가득 차서 상당히 위험한 상황이야.\\t이런… 왜놈들이다. 자네에게 고양이를 맡겨도 되겠나? 부탁하지.','야옹~ 나는 호랑이 파의 귀염둥이 고양이~\\t이 거북선과 무기들만 있으면 이 땅은 호랑이 님의 것이야!\\t돌려 달라고? 너 건방지구나?','음~ 나와 말을 섞을 정도 머리는 되네?\\t그럼 한 번 뺏어가봐!','다녀왔나? 나도 지금 왜선 10척을 바다에 수장시키고 왔지.\\t음, 멀쩡하군! 무기도 다 그대로야! 수고했네.\\t보답으로 이 거북선 안에서 뭐든지 하나 가져가게.\\t응? 내 일기를 달라고? 안될 건 없네만…\\t근데 그 일기 사이에 있는 천은 뭔가? 고양이가 흘리고 간 모양이군. 한 번 조사해보게.',16,'남쪽 바다가 시끄럽다는 소문을 들었다. 이순신을 찾아가 단서를 찾아보자.','죽고자 하면 살 것이요. 살고자 하면 죽을 것이다.'),(7,'유관순',250,7,'안녕하세요? 누구시죠? 그건…\\t네 저희가 만든 태극기에요. 사실 어제 모두 도둑맞아 버려서 곤란하던 참이었어요.\\t저희를 도와주신다고요? 정말 감사합니다!\\t태극기는 호랑이의 부하인 소가 훔쳐갔어요! 제발 찾아주세요!','음메~ 나는 소야.\\t호랑이 님이 태극기 훔쳐서 일본 순사한테 일러버리라 했어.\\t응? 돌려 달라고? 너 일제강점기에 대해 좀 알아?','음메~ 너 좀 아는구나?\\t그럼 내가 힘이 세다는 것도 알아?','와! 감사합니다!\\t이제 이 태극기를 갖고 천안에서 만세 운동을 할 거에요!\\t태극기 한 장 드릴게요! 부디 함께 해 주세요!\\t참, 호랑이는 백두산에 숨어 있다고 하던데… 한 번 찾아가 보시겠어요?',17,'찢어진 태극기를 발견했다. 유관순을 찾아가 단서를 찾아보자.','대한 독립 만세!'),(8,'호랑이',250,8,'어흥! 내가 있는 곳을 용케도 찾아왔구나!\\t올라와라!','오랜만이다. 허준의 제자…\\t동의보감을 돌려 달라고? 그럼 퀴즈를 맞춰 보시지.','어흥!역시 머리 쓰는 건 나랑 안 맞아!\\t덤벼라!','오오… 동의보감을 찾아왔구나!',18,'호랑이가 숨은 곳을 알아냈다. 호랑이를 혼내주자.','어흥!');
/*!40000 ALTER TABLE `mission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `monster`
--

DROP TABLE IF EXISTS `monster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `monster` (
  `monster_id` bigint NOT NULL AUTO_INCREMENT,
  `attack` int DEFAULT NULL,
  `hp` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `defence` int DEFAULT NULL,
  `growth_attack` int DEFAULT NULL,
  `growth_defence` int DEFAULT NULL,
  `growth_hp` int DEFAULT NULL,
  PRIMARY KEY (`monster_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `monster`
--

LOCK TABLES `monster` WRITE;
/*!40000 ALTER TABLE `monster` DISABLE KEYS */;
INSERT INTO `monster` VALUES (1,100,400,'개나리몬',70,30,30,100),(2,80,500,'도꼬마리몬',100,20,50,150),(3,150,300,'마늘몬',50,40,10,100),(4,130,650,'석류몬',70,35,40,80);
/*!40000 ALTER TABLE `monster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz`
--

DROP TABLE IF EXISTS `quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz` (
  `quiz_id` bigint NOT NULL AUTO_INCREMENT,
  `answer1` varchar(255) DEFAULT NULL,
  `answer2` varchar(255) DEFAULT NULL,
  `answer3` varchar(255) DEFAULT NULL,
  `question` varchar(255) DEFAULT NULL,
  `right_answer` varchar(255) DEFAULT NULL,
  `mission_id` bigint DEFAULT NULL,
  `answer4` varchar(255) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`quiz_id`),
  KEY `FK8l4mnrefd1yvtrf8rgshbayc1` (`mission_id`),
  CONSTRAINT `FK8l4mnrefd1yvtrf8rgshbayc1` FOREIGN KEY (`mission_id`) REFERENCES `mission` (`mission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz`
--

LOCK TABLES `quiz` WRITE;
/*!40000 ALTER TABLE `quiz` DISABLE KEYS */;
INSERT INTO `quiz` VALUES (1,'청동 거울','고인돌','간석기','(가) 시대와 관련 있는 유물이 아닌 것은?','간석기',1,'비파형 동검','https://img.comcbt.com/cbt/data/k3/k320200208/k320200208m1.gif?1581317351'),(2,'고인돌 덮개돌 끌기','철제 농기구로 밭 일구기','갈판과 갈돌로 곡식 갈기','(가)에 들어갈 내용으로 가장 적절한 것은?','갈판과 갈돌로 곡식 갈기',1,'비파형 동검 모형 만들기','https://img.comcbt.com/cbt/data/k3/k320181027/k320181027m1.gif?1540875895'),(3,'비파형 동검','빗살무늬 토기','철제 갑옷','다음 유적이 만들어진 시기에 사용되었던 유물로 옳은 것은?','빗살무늬 토기',1,'청동 거울','https://img.comcbt.com/cbt/data/k3/k320130126/k320130126m1.gif?1476226581'),(4,'살수 대첩','행주 대첩','진포 대첩','밑줄 그은 ‘나’가 이끈 전투로 옳은 것은?','살수 대첩',2,'황산 대첩','https://img.comcbt.com/cbt/data/k3/k320191027/k320191027m3.gif?1573301993'),(5,'무령왕','진흥왕','고국천왕','다음 가상 인터뷰에 등장하는 왕으로 옳은 것은?','소수림왕',2,'소수림왕','https://img.comcbt.com/cbt/data/k3/k320161022/k320161022m5.gif?1477283995'),(6,'법흥왕','근초고왕','의자왕','밑줄 그은 ‘이 왕’으로 옳은 것은?','법흥왕',2,'광개토대왕','https://img.comcbt.com/cbt/data/k3/k320160123/k320160123m5.gif?1476226674'),(7,'김유신','김춘추','장보고','다음 인물 카드의 주인공으로 옳은 것은?','김유신',2,'최치원','https://img.comcbt.com/cbt/data/k3/k320131026/k320131026m6.gif?1476226608'),(8,'의창','환곡','상평창','다음 대본에 등장하는 왕이 실시한 제도로 옳은 것은?','진대법',2,'진대법','https://img.comcbt.com/cbt/data/k3/k320140524/k320140524m2.gif?1476226618'),(9,'골품 제도','음서 제도','화랑 제도','밑줄 그은 ‘신분 제도’로 옳은 것은?','골품 제도',3,'화백 제도','https://img.comcbt.com/cbt/data/k3/k320130126/k320130126m8.gif?1476226588'),(10,'도침','복신','흑치상치','(가)에 들어갈 인물로 옳지 않은 것은?','연개소문',3,'연개소문','https://img.comcbt.com/cbt/data/k3/k320141025/k320141025m12.gif?1476226631'),(11,'이순신','정중부','강감찬','다음 설명에 해당하는 인물로 옳은 것은?','장보고',3,'장보고','https://img.comcbt.com/cbt/data/k3/k320120818/k320120818m7.gif?1476226574'),(12,'고주몽','왕건','대조영','(가) 나라를 세운 인물로 옳은 것은?','대조영',3,'김수로','https://img.comcbt.com/cbt/data/k3/k320131026/k320131026m9.gif?1476226608'),(13,'왕건','궁예','신검','다음 학생이 생각하고 있는 인물로 옳은 것은?','궁예',3,'견훤','https://img.comcbt.com/cbt/data/k3/k320190126/k320190126m11.gif?1549750835'),(14,'삼별초','별무반','별기군','다음 가상 상장을 받은 사람이 조직한 특수 부대로 옳은 것은?','별무반',4,'훈련도감','https://img.comcbt.com/cbt/data/k3/k320131026/k320131026m12.gif?1476226602'),(15,'(가)','(나)','(다)','고려 시대 문화관에 들어 있는 문화유산으로 적절하지 않은 것은?','(가)',4,'(라)','https://img.comcbt.com/cbt/data/k3/k320111022/k320111022m14.gif?1476226546'),(16,'망이·망소이의 난','무신정변','원종과 애노의 난','다음 만화 장면에 해당하는 사건으로 옳은 것은?','무신정변',4,'갑신정변','https://img.comcbt.com/cbt/data/k3/k320190126/k320190126m20.gif?1549750836'),(17,'만적의 난','팔만대장경판 제작','망이·망소이의 난','연표의 (가) 시기에 있었던 사실로 옳지 않은 것은?','팔만대장경판 제작',4,'윤관의 동북 9성 개척','https://img.comcbt.com/cbt/data/k3/k320130126/k320130126m17.gif?1476226583'),(18,'태조','광종','공민왕','(가)에 들어갈 왕으로 옳은 것은?','광종',4,'충렬왕','https://img.comcbt.com/cbt/data/k3/k320180811/k320180811m14.gif?1535439853'),(19,'측우기 제작','농사직설 보급','수원 화성 축조','밑줄 그은 ‘왕’의 업적으로 옳지 않은 것은?','수원 화성 축조',5,'삼강행실도 편찬','https://img.comcbt.com/cbt/data/k3/k320150808/k320150808m27.gif?1476226655'),(20,'영조','선조','태종','(가)에 들어갈 왕으로 옳은 것은?','태종',5,'광종','https://img.comcbt.com/cbt/data/k3/k320190126/k320190126m22.gif?1549750836'),(21,'한산도 대첩','행주 대첩','진주성 대첩','자료 속 인물과 관련된 역사적 사실로 옳은 것은?','한산도 대첩',5,'귀주 대첩','https://img.comcbt.com/cbt/data/k3/k320111022/k320111022m19.gif?1476226546'),(22,'조선경국전','대전회통','경국대전','(가)에 들어갈 내용으로 옳은 것은?','경국대전',5,'대전통편','https://img.comcbt.com/cbt/data/k3/k320180527/k320180527m23.gif?1527514651'),(23,'종묘','경복궁','보신각','밑줄 그은 ‘이곳’에 해당하는 문화유산의 이름으로 옳은 것은?','종묘',5,'사직단','https://img.comcbt.com/cbt/data/k3/k320171028/k320171028m27.gif?1517336979'),(24,'삼포왜란','임진왜란','정묘호란','다음에 해당하는 역사적 사건으로 옳은 것은?','병자호란',6,'병자호란','https://img.comcbt.com/cbt/data/k3/k320121027/k320121027m27.gif?1476226578'),(25,'박제가','정약전','박지원','밑줄 그은 ‘이 사람’으로 옳은 것은?','홍대용',6,'홍대용','https://img.comcbt.com/cbt/data/k3/k320180811/k320180811m25.gif?1535439854'),(26,'북벌 추진','척화비 건립','경국대전 완성','밑줄 그은 ‘이 왕’의 업적으로 옳은 것은?','수원 화성 건설',6,'수원 화성 건설','https://img.comcbt.com/cbt/data/k3/k320160813/k320160813m30.gif?1476226686'),(27,'갑신정변','병인양요','신미양요','다음 자료에서 설명하는 사건으로 옳은 것은?','병인양요',6,'임오군란','https://img.comcbt.com/cbt/data/k3/k320151024/k320151024m31.gif?1476226663'),(28,'수원 화성 건설','집현전 설치','당백전 발행','다음 자료에 나타난 왕의 업적으로 옳은 것은?','균역법 실시',6,'균역법 실시','https://img.comcbt.com/cbt/data/k3/k320141025/k320141025m26.gif?1476226634'),(29,'김구','박은식','이봉창','다음 인물 카드의 주인공으로 옳은 것은?','이봉창',7,'안중근','https://img.comcbt.com/cbt/data/k3/k320120114/k320120114m20.gif?1476226553'),(30,'신민회','북로 군정서','한국 광복군','다음 가상 인터뷰에서 밑줄 그은‘비밀 단체’로 옳은 것은?','신민회',7,'조선 의용대','https://img.comcbt.com/cbt/data/k3/k320120114/k320120114m34.gif?1476226556'),(31,'광혜원','신민회','대한민국 임시 정부','생각 지도 (가)에 들어갈 내용으로 적절한 것은?','대한민국 임시 정부',7,'독립 협회','https://img.comcbt.com/cbt/data/k3/k320111022/k320111022m28.gif?1476226548'),(32,'김원봉','안창호','윤봉길','(가)에 해당하는 인물로 옳은 것은?','장인환',7,'장인환','https://img.comcbt.com/cbt/data/k3/k320190126/k320190126m26.gif?1549750836'),(33,'3·1 운동','광주 학생 항일 운동','국채 보상 운동','(가)에 들어갈 내용으로 옳은 것은?','국채 보상 운동',7,'6·10 만세 운동','https://img.comcbt.com/cbt/data/k3/k320161022/k320161022m33.gif?1477283993'),(34,'고구려인의 의생활','발해인의 무역 활동','백제인의 해외진출','(가)에 들어갈 내용으로 적절한 것은?','고구려인의 의생활',8,'신라인의 종교 생활','https://img.comcbt.com/cbt/data/k3/k320171028/k320171028m8.gif?1517336981'),(35,'영선사','연행사','조사 시찰단','(가)에 들어갈 사절단으로 옳은 것은?','통신사',8,'통신사','https://img.comcbt.com/cbt/data/k3/k320180203/k320180203m30.gif?1518210951'),(36,'계백','최무선','곽재우','다음 가상 인터뷰의 주인공으로 옳은 것은?','곽재우',8,'을지문덕','https://img.comcbt.com/cbt/data/k3/k320180203/k320180203m24.gif?1518210950'),(37,'(가) - (나) - (다)','(가) - (다) - (나)','(나) - (가) - (다)','(가)~(다)의 사건을 일어난 순서대로 옳게 나열한 것은?','(가) - (나) - (다)',8,'(다) - (가) - (나)','https://img.comcbt.com/cbt/data/k3/k320180203/k320180203m21.gif?1518210950'),(38,'(가)','(나)','(다)','밑줄 그은 ‘조약’이 체결된 시기를 연표에서 옳게 고른 것은?','(라)',8,'(라)','https://img.comcbt.com/cbt/data/k3/k320170527/k320170527m35.gif?1496784659'),(39,'신문왕','무열왕','법흥왕','(가)에 들어갈 왕으로 옳은 것은?','신문왕',8,'진흥왕','https://img.comcbt.com/cbt/data/k3/k320170121/k320170121m7.gif?1485229220'),(40,'백강 전투','청산리 전투','쌍성보 전투','다음 대본에 나타난 전투로 옳은 것은?','청산리 전투',8,'매소성 전투','https://img.comcbt.com/cbt/data/k3/k320160528/k320160528m37.gif?1476226681');
/*!40000 ALTER TABLE `quiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `users_id` bigint NOT NULL AUTO_INCREMENT,
  `created_date` datetime(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `monster_id` bigint DEFAULT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  `now_mission_id` bigint DEFAULT NULL,
  PRIMARY KEY (`users_id`),
  KEY `FK20l270v6g1uqdsh9de6n6qu9d` (`monster_id`),
  CONSTRAINT `FK20l270v6g1uqdsh9de6n6qu9d` FOREIGN KEY (`monster_id`) REFERENCES `monster` (`monster_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users_item`
--

DROP TABLE IF EXISTS `users_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_item` (
  `users_item_id` bigint NOT NULL AUTO_INCREMENT,
  `count` int DEFAULT NULL,
  `item_id` bigint DEFAULT NULL,
  `users_id` bigint DEFAULT NULL,
  PRIMARY KEY (`users_item_id`),
  KEY `FKlbhvc3s3hbalugnayw02m5ejj` (`item_id`),
  KEY `FK8krg35sjgtquidnfb0hoj2gaf` (`users_id`),
  CONSTRAINT `FK8krg35sjgtquidnfb0hoj2gaf` FOREIGN KEY (`users_id`) REFERENCES `users` (`users_id`),
  CONSTRAINT `FKlbhvc3s3hbalugnayw02m5ejj` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_item`
--

LOCK TABLES `users_item` WRITE;
/*!40000 ALTER TABLE `users_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_mission`
--

DROP TABLE IF EXISTS `users_mission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_mission` (
  `users_mission_id` bigint NOT NULL AUTO_INCREMENT,
  `status` varchar(255) DEFAULT NULL,
  `mission_id` bigint DEFAULT NULL,
  `users_id` bigint DEFAULT NULL,
  PRIMARY KEY (`users_mission_id`),
  KEY `FKeijndh3a2852xodx6f4a6obcj` (`mission_id`),
  KEY `FKa6jp9gto6l4tyg6914r0fwp35` (`users_id`),
  CONSTRAINT `FKa6jp9gto6l4tyg6914r0fwp35` FOREIGN KEY (`users_id`) REFERENCES `users` (`users_id`),
  CONSTRAINT `FKeijndh3a2852xodx6f4a6obcj` FOREIGN KEY (`mission_id`) REFERENCES `mission` (`mission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=273 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `users_monster`
--

DROP TABLE IF EXISTS `users_monster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_monster` (
  `users_monster_id` bigint NOT NULL AUTO_INCREMENT,
  `exp` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `monster_id` bigint DEFAULT NULL,
  `users_id` bigint DEFAULT NULL,
  PRIMARY KEY (`users_monster_id`),
  KEY `FKjwlvqluvc72wm8fov4vyvdlh5` (`monster_id`),
  KEY `FKj5kw1sq1pmv040lbj31pembld` (`users_id`),
  CONSTRAINT `FKj5kw1sq1pmv040lbj31pembld` FOREIGN KEY (`users_id`) REFERENCES `users` (`users_id`),
  CONSTRAINT `FKjwlvqluvc72wm8fov4vyvdlh5` FOREIGN KEY (`monster_id`) REFERENCES `monster` (`monster_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-08 15:59:19
