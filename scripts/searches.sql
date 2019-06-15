USE a_game_of_thrones

-- Get id, name, father name and mother name of every person
SELECT people.id, people.name, men.name as father_name, women.name as mother_name
FROM people
LEFT JOIN (
  SELECT people.id, people.name
  FROM people
  WHERE gender = "m"
) AS men
ON men.id = people.father_id
LEFT JOIN (
  SELECT people.id, people.name
  FROM people
  WHERE gender = "f"
) AS women
ON women.id = people.mother_id;

-- Get id, name and house of every noble
SELECT people.id, people.name, houses.name, houses.words
FROM people
RIGHT JOIN nobles
ON nobles.person_id = people.id
LEFT JOIN inheritances
ON inheritances.noble_id = nobles.id
JOIN houses
ON houses.id = inheritances.house_id;

-- Get the name, symbol, colors, words and number of members of each house
SELECT houses.name, houses.symbol, houses.colors, houses.words AS motto, count(people.id) AS members
FROM houses
LEFT JOIN inheritances
ON inheritances.house_id = houses.id
LEFT JOIN nobles
ON nobles.id = inheritances.noble_id
JOIN people
ON nobles.person_id = people.id
GROUP BY houses.id
ORDER BY members DESC;

-- Get the name and the house of each person whom does not carry one (or more) of their families names
SELECT people.id, people.name, houses.name
FROM people
RIGHT JOIN nobles
ON nobles.person_id = people.id
LEFT JOIN inheritances
ON inheritances.noble_id = nobles.id
JOIN houses
ON houses.id = inheritances.house_id
WHERE NOT people.name LIKE concat('%', houses.name, '%')
ORDER BY houses.name;

-- Get alive people
SELECT people.id, people.name, people.gender, regions.name AS region
FROM people
JOIN regions
ON people.region_id = regions.id
WHERE people.is_alive = 1;

-- Get every married couple and their number of children
SELECT husbands.name AS father_name, wives.name AS mother_name, count(children.id) AS children_number
FROM (
  SELECT people.id, people.name, marriages.wife_id
  FROM people
  JOIN marriages
  ON marriages.husband_id = people.id
) AS husbands
JOIN (
  SELECT people.id, people.name, marriages.husband_id
  FROM people
  JOIN marriages
  ON marriages.wife_id = people.id
) AS wives
ON wives.husband_id = husbands.id
LEFT JOIN (
  SELECT people.id, people.father_id, people.mother_id
  FROM people
) AS children
ON children.father_id = husbands.id AND children.mother_id = wives.id
GROUP BY husbands.id, wives.id
ORDER BY children_number DESC;

-- Get the id, name and number of children of each person with at least one children
SELECT people.id, people.name, count(children.id) AS children_number
FROM people
LEFT JOIN (
  SELECT people.id, people.father_id, people.mother_id
  FROM people
  WHERE father_id IS NOT NULL OR mother_id IS NOT NULL
) AS children
ON (children.father_id = people.id OR children.mother_id = people.id)
GROUP BY people.id
HAVING children_number > 0
ORDER BY children_number DESC;

-- Get each castle every lord has ruled
SELECT lords_castles.id, people.name AS lord_name, castles.name AS castle_name, lords_castles.is_current_ruler AS current_ruler
FROM people
LEFT JOIN nobles
ON nobles.person_id = people.id
LEFT JOIN lords
ON lords.noble_id = nobles.id
JOIN lords_castles
ON lords_castles.lord_id = lords.id
JOIN castles
ON lords_castles.castle_id = castles.id
ORDER BY castle_name;

-- Get the current lord of each castle
SELECT people.name AS lord_name, castles.name AS castle_name
FROM castles
LEFT JOIN lords_castles
ON lords_castles.castle_id = castles.id
LEFT JOIN lords
ON lords.id = lords_castles.lord_id
LEFT JOIN nobles
ON nobles.id = lords.noble_id
LEFT JOIN people
ON people.id = nobles.person_id
WHERE lords_castles.is_current_ruler = 1
ORDER BY castle_name;

-- Get the current warden of each region
SELECT people.name AS warden_name, regions.name AS region_name
FROM people
JOIN nobles
ON nobles.person_id = people.id
JOIN lords
ON lords.noble_id = nobles.id
JOIN great_lords
ON great_lords.lord_id = lords.id
JOIN wardens
ON wardens.lord_id = great_lords.id
JOIN regions
ON regions.id = wardens.region_id
ORDER BY region_name;

-- Get every king and the kingdom he ruled
SELECT people.name AS king_name, kingdoms.name AS kingdom_name, reigns.is_current_ruler
FROM kingdoms
JOIN reigns
ON kingdoms.id = reigns.kingdom_id
JOIN kings
ON kings.id = reigns.king_id
JOIN nobles
ON kings.noble_id = nobles.id
JOIN people
ON nobles.person_id = people.id
ORDER BY kingdom_name;

-- Get the current king of each kingdom
SELECT people.name AS king_name, kingdoms.name AS kingdom_name
FROM kingdoms
JOIN reigns
ON kingdoms.id = reigns.kingdom_id
JOIN kings
ON kings.id = reigns.king_id
JOIN nobles
ON kings.noble_id = nobles.id
JOIN people
ON nobles.person_id = people.id
WHERE reigns.is_current_ruler = 1
ORDER BY kingdom_name;
