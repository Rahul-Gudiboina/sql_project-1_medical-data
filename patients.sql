use project_medical_data_history;
select * from patients;
select * from doctors;
select * from province_names;
select * from admissions;


#1. Show first name, last name, and gender of patients who's gender is 'M'
select first_name,last_name,gender from patients where gender='M';

#2. Show first name and last name of patients who does not have allergies.
select first_name, last_name from patients where allergies is null or allergies=" ";

#3. Show first name of patients that start with the letter 'C
select first_name from patients where first_name like 'C%';

#4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name, last_name from patients where weight between "100" and "120";

#5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update patients set allergies= "NKA" where allergies is null;
/* Here, my query is right but its getting error like host denied permission to update it.*/


#6. Show first name and last name concatenated into one column to show their full name.
select concat(first_name,' ',last_name) as fullname from patients;

#7. Show first name, last name, and the full province name of each patient.
describe province_names;
select p.first_name,p.last_name,pn.province_name from patients p inner join province_names pn on p.province_id=pn.province_id;

#8. Show how many patients have a birth_date with 2010 as the birth year.
select count(*) from patients where birth_date like "%2010%";

#9. Show the first_name, last_name, and height of the patient with the greatest height.
select first_name, last_name,height from patients where height =(select max(height) from patients);

#10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select * from patients where patient_id in(1,45,534,879,1000);

#11.Show the total number of admissions
select count(*) as total_admissions from admissions;

#12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
select * from admissions where admission_date=discharge_date;

#13. Show the total number of admissions for patient_id 579.
select count(*) as totaladmissions from admissions where patient_id="579";

#14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct city from patients where province_id="NS"; 

#15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name,last_name,birth_date from patients where height >160 and weight >70;

#16. Show unique birth years from patients and order them by ascending.
select distinct year(birth_date) as birth_year from patients order by birth_year asc;

#17. Show unique first names from the patients table which only occurs once in the list.
select distinct first_name from patients group by  first_name having count(first_name)=1;

#18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id,first_name from patients where first_name like "s%s" and length(first_name)>=6;

#19. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
select p.patient_id, p.first_name,p.last_name from patients p inner join admissions ad on p.patient_id = ad.patient_id where ad.diagnosis="dementia";

#20. Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
select first_name from patients order by length(first_name),first_name;

#21. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row
select (select count(*) from patients where gender="m") as total_male_patients,
(select count(*) from patients where gender="f") as total_female_patients;

#22. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select(select count(*) from patients where gender="m")as total_male_patients,(select count(*) from patients where gender="f")as total_female_patients;

#23. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id, diagnosis,count(*) as admission_count from admissions group by patient_id, diagnosis having count(*)>1;

#24. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending
select city,count(*) as total_patients from patients group by city order by total_patients desc, city asc;

#25. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor".
select first_name,last_name,'patients' as role from patients union all select first_name,last_name,'doctor' as role from doctors;

#26. Show all allergies ordered by popularity. Remove NULL values from query.
select allergies,count(*) as popularity from patients where allergies is not null group by allergies order by popularity desc;

#27. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name,last_name,birth_date from patients where birth_date between "1970-01-01" and "1980-01-01" order by birth_date;

/*28. We want to display each patient's full name in a single column. 
Their last_name in all upper letters must appear first, then first_name in all lower case letters.
 Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane*/
 select concat(upper(last_name),',',lower(first_name)) as 'fullname' from patients order by first_name desc;
 
 #29. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
 select province_id, sum(height) as total_sum from patients group by province_id having sum(height) >=7000;
 
 #30. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni
 select max(weight)-min(weight) as weight_difference from patients where last_name='maroni';
 
 #31. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
 select day(admission_date) as day_of_month,count(*) as admissions_occured from admissions group by day(admission_date)order by admissions_occured desc;
 
/* #32. Show all of the patients grouped into weight groups. Show the total
amount of patients in each weight group. Order the list by the weight group
decending. e.g. if they weight 100 to 109 they are placed in the 100 weight
group, 110-119 = 110 weight group, etc.*/
SELECT 
    CASE
        WHEN weight BETWEEN 100 AND 109 THEN '100-109'
        WHEN weight BETWEEN 110 AND 119 THEN '110-119'
        WHEN weight BETWEEN 120 AND 129 THEN '120-129'
        WHEN weight BETWEEN 130 AND 139 THEN '130-139'
        ELSE 'Other'
    END AS weight_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

/* #33. Show patient_id, weight, height, isObese from the patients table. Display
isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m).
Weight is in units kg. Height is in units cm.*/

SELECT 
    patient_id,
    weight,
    height,
    CASE 
        WHEN weight / ((height / 100) * (height / 100)) >= 30 THEN 1
        ELSE 0
    END AS isObese
FROM 
    patients;

/* #34. Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first
name is 'Lisa'. Check patients, admissions, and doctors tables for required
information. */
SELECT p.patient_id, p.first_name, p.last_name, d.specialty
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON p.patient_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
AND d.first_name = 'Lisa';

/* 35.  All patients who have gone through admissions, can see their medical 
documents on our site. Those patients are given a temporary password after
their first admission. Show the patient_id and temp_password.
The password must be the following, in order:
patient_id the numerical length of patient's last_name year of patient's birth_date */
SELECT patient_id,CONCAT(patient_id, LENGTH(last_name), YEAR(birth_date)) AS temp_password FROM patients;
