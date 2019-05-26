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
