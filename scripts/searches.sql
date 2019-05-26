USE a_game_of_thrones

-- Get id, name, father name and mother name of every person
SELECT people.id, people.name, fathers.name as father_name, mothers.name as mother_name
FROM people
LEFT JOIN (
  SELECT people.id, people.name
  FROM people
  WHERE gender = "m"
) AS fathers
ON fathers.id = people.father_id
LEFT JOIN (
  SELECT people.id, people.name
  FROM people
  WHERE gender = "f"
) AS mothers
ON mothers.id = people.mother_id;

-- Get id, name and house of every noble
SELECT people.id, people.name, houses.name, houses.words
FROM people
RIGHT JOIN nobles
ON nobles.person_id = people.id
LEFT JOIN inheritances
ON inheritances.noble_id = nobles.id
JOIN houses
ON houses.id = inheritances.house_id;

-- Get alive people
SELECT people.id, people.name, people.gender, regions.name AS region
FROM people
JOIN regions
ON people.region_id = regions.id
WHERE people.is_alive = 1;

-- Get every married couple and their number of sons
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
GROUP BY husbands.id, wives.id;

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
