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
