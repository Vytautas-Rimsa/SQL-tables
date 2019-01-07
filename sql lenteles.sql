--lenteles sukurimas
CREATE TABLE korys (
	elemento_id INT AUTO_INCREMENT PRIMARY KEY,
	pavadinimas VARCHAR(20) NOT NULL,
	aprasymas VARCHAR(100),
	dokumentas BLOB,
	lft INT NOT NULL,
	rgt INT NOT NULL
);

-- suvedame duomenis i lentele
INSERT INTO korys VALUES(1,'KORYS','','',1,18),
	(2,'APIE','','',2,5),
	(3,'KONTAKTAI','','',3,4),
	(4,'SOCIALINIAI TINKLAI','','',6,11),
	(5,'FACEBOOK','http://www.facebook.com','',7,8),
	(6,'TWITTER','http://www.twitter.com','',9,10),
	(7,'DOKUMENTAI','','',12,17),
	(8,'ANKETA','',LOAD_FILE('C:/dokumentai/anketa.docx'),13,14),
	(9,'SKAICIUOKLE','',LOAD_FILE('C:/dokumentai/calc.xlsx'),15,16);
	
-- patikrinam suvestus duomenis pagal elemento ID
SELECT * FROM korys ORDER BY elemento_id;

-- tevo elemento irasymas
LOCK TABLE korys WRITE;

SELECT @myRight := rgt FROM korys
WHERE pavadinimas = 'SOCIALINIAI TINKLAI';

UPDATE korys SET rgt = rgt + 2 WHERE rgt > @myRight;
UPDATE korys SET lft = lft + 2 WHERE lft > @myRight;

INSERT INTO korys(pavadinimas, aprasymas, dokumentas,lft, rgt) VALUES('KNYGOS','','', @myRight + 1, @myRight + 2);

UNLOCK TABLES;

-- vaiko elemento irasymas
LOCK TABLE korys WRITE;

SELECT @myLeft := lft FROM korys

WHERE pavadinimas = 'KNYGOS';

UPDATE korys SET rgt = rgt + 2 WHERE rgt > @myLeft;
UPDATE korys SET lft = lft + 2 WHERE lft > @myLeft;

INSERT INTO korys(pavadinimas, aprasymas, dokumentas,lft, rgt) VALUES('Raganius', 'Autorius: Andrzej Sapkowski','',@myLeft + 1, @myLeft + 2);

UNLOCK TABLES;

--isvedame visus elementu pavadinimus
SELECT elementas.pavadinimas
FROM korys AS elementas,
        korys AS parent
WHERE elementas.lft BETWEEN parent.lft AND parent.rgt
        AND parent.pavadinimas = 'KORYS'
ORDER BY elementas.lft;

--isvedame visus vaiko elementus
SELECT pavadinimas
FROM korys
WHERE rgt = lft + 1;

--isvedame visu elementu gyli
SELECT elementas.pavadinimas, (COUNT(parent.pavadinimas) - 1) AS depth
FROM korys AS elementas,
        korys AS parent
WHERE elementas.lft BETWEEN parent.lft AND parent.rgt
GROUP BY elementas.pavadinimas
ORDER BY elementas.lft;

