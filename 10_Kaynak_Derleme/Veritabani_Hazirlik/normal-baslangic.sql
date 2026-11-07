-- Local normal-progression profile. IDs are existing, level-zero ITEM records;
-- this is a deliberate lab preset, not a claim to reproduce official USKO rates.
IF OBJECT_ID('dbo.KNIGHTLAB_NORMAL_STARTER_ITEMS','U') IS NULL
 CREATE TABLE dbo.KNIGHTLAB_NORMAL_STARTER_ITEMS(ClassType smallint NOT NULL,SlotID tinyint NOT NULL,ItemID int NOT NULL,
  CONSTRAINT PK_KNIGHTLAB_NORMAL_STARTER_ITEMS PRIMARY KEY(ClassType,SlotID));
DECLARE @wanted TABLE(ClassType smallint,SlotID tinyint,ItemID int);
INSERT @wanted VALUES
(1,1,201013000),(1,4,201011000),(1,10,201012000),(1,12,201014000),(1,13,201015000),(1,6,121470000),
(2,1,241013000),(2,4,241011000),(2,10,241012000),(2,12,241014000),(2,13,241015000),(2,6,111410000),
(3,1,261013000),(3,4,261011000),(3,10,261012000),(3,12,261014000),(3,13,261015000),(3,6,181470000),
(4,1,281013000),(4,4,281011000),(4,10,281012000),(4,12,281014000),(4,13,281015000),(4,6,191410000),
(13,6,120010000);
IF EXISTS(SELECT 1 FROM @wanted w LEFT JOIN ITEM i ON i.num=w.ItemID
 WHERE i.num IS NULL OR i.reqlevel>1 OR i.class NOT IN(0,w.ClassType) OR i.reqstr>0 OR i.reqdex>0 OR i.reqintel>0 OR i.reqcha>0)
 THROW 51100,'Normal starter item is missing or has incompatible requirements',1;
IF EXISTS(SELECT ClassType,SlotID,ItemID FROM dbo.KNIGHTLAB_NORMAL_STARTER_ITEMS EXCEPT SELECT ClassType,SlotID,ItemID FROM @wanted)
 THROW 51101,'Existing normal starter preset differs; inspect it before replacing',1;
INSERT dbo.KNIGHTLAB_NORMAL_STARTER_ITEMS SELECT * FROM @wanted w
 WHERE NOT EXISTS(SELECT 1 FROM dbo.KNIGHTLAB_NORMAL_STARTER_ITEMS s WHERE s.ClassType=w.ClassType AND s.SlotID=w.SlotID);
