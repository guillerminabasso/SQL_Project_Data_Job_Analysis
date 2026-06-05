----- FINISH 5. , REORGANIZE AND ADD CHARTS. SUM IT UP A BIT

# SQL Project Data Job Analysis

## Introduction

This project explores the Data Analytics job market in 2023 through SQL-based analysis. It was developed as part of a YouTube SQL course, which provided the datasets and the overall structure of the analysis.

While following the course framework, I expanded several sections by conducting additional analyses whenever I felt a deeper investigation would provide more meaningful insights or help me better understand the data and the tools involved.

In addition to the SQL queries covered in the course, I performed supplementary analyses using Excel and basic statistical techniques, including salary distribution analysis, outlier detection using the Interquartile Range (IQR) method, and data visualization. These extensions allowed me to practice a broader set of data analytics skills and gain deeper insights into the job market.

This project therefore reflects both the course objectives and my own analytical approach to exploring salary trends, in-demand skills, and job market characteristics.

🔍 SQL queries? Check them out here: [[project_sql folder](/project_sql/)](https://github.com/guillerminabasso/SQL_Project_Data_Job_Analysis/tree/main/project.sql)

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

### Tools I Used

- **SQL:** Used to extract, clean, join, and analyze job posting data, allowing me to identify salary trends and in-demand skills.
- **PostgreSQL:** The chosen database management system to query and analyze the dataset, uncovering trends in salaries, skills, and job demand.
- **Visual Studio Code:** Used to write and manage SQL queries and organize the project's code and documentation.
- **Git & GitHub:** Used for version control, project organization, and portfolio presentation.
- **Excel:** Used to analyze the detailed dataset generated from the drill-down analysis and transform it into clear, easy-to-understand charts and visual summaries.
- **ChatGPT:** supported the research process by helping me understand unfamiliar skills and technologies identified in the analysis.

## The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s the results:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary focusing on remote jobs and joined with the companies dataset. This query highlights the high paying opportunities in the field.

```sql
SELECT 
    job_title,
    job_location,
    job_country,
    salary_year_avg,
    name AS company
FROM 
    job_postings_fact
LEFT JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    salary_year_avg IS NOT NULL
AND 
    job_work_from_home IS TRUE AND 
    job_title_short = 'Data Analyst'
ORDER BY 
    salary_year_avg DESC
LIMIT 10
```
Here's the breakdown of the top data analyst jobs in 2023:

<img width="496" height="299" alt="image" src="https://github.com/user-attachments/assets/cdc6953a-08ab-4951-920d-641d6f6a01c2" />

<img width="717" height="182" alt="image" src="https://github.com/user-attachments/assets/483054bc-32fc-49a8-aaa3-be33bcefcc25" />


First insights:
1. Highest salary value is $650.0000, while the second highest salary is $400.000. I wonder if the first value could represent an outlier?
2. The job with the highest salary is located in India, the following 9 are american-based companies.
3. The companies associated with the 10 highest salaries represent different industries which shows a wide range of well-payed opportunities in different fields.


#### 🔎 Drill-down Analysis

To further investigate the highest-paying role identified in the initial query, a detailed dataset of remote Data Analyst job postings was extracted (LIMIT 10 from previous query was deleted), focusing on raw salary values without joins or aggregations.

```sql
SELECT 
    job_title,
    ROUND(salary_year_avg,0) AS salary
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
AND 
    salary_year_avg IS NOT NULL
AND 
    job_work_from_home IS TRUE
ORDER BY salary DESC
```
The resulting dataset (~600 records) was exported to Excel for statistical analysis.

#### 🔗 Linking SQL Top 10 with IQR Analysis

The exported salary distribution was analyzed using the Interquartile Range (IQR) method to assess whether the highest salary identified in the SQL query ($650,000) could be considered an anomaly.

The IQR analysis identified 26 outliers, 25 of which correspond to the highest salary values in the dataset. This confirms that most of the top-paying roles identified in the SQL ranking fall within the extreme upper tail of a right-skewed salary distribution.

Rather than indicating data errors, these values represent high-paying niche roles that naturally exist within the market. 

<img width="535" height="351" alt="image" src="https://github.com/user-attachments/assets/ce679f5e-3cdb-44f4-8f77-30855c06ffd3" />




#### 🔎 Conclusion (Histogram + Outliers Interpretation)

The histogram shows that the majority of Data Analyst salaries are concentrated between approximately $25,000 and $125,000, indicating a strong central distribution within this range. This reflects a relatively consistent salary band for most roles in the dataset.

However, the distribution is highly right-skewed, with a small number of salaries extending beyond $600,000. These values are rare and have limited visual impact in the histogram due to their low frequency.

The IQR analysis confirms that these extreme values are statistically identified as outliers. However, they do not indicate data errors, but rather represent highly specialized or senior-level roles that command significantly higher compensation than the market baseline.

Overall, the salary distribution follows a typical labor market pattern, with a dense concentration of standard roles and a long tail of high-paying niche positions.


### 2. Skills for Top Paying Jobs

To identify the skills associated with the 10 highest paying jobs, I joined the job postings dataset with the skills data in order to gain deeper insights into the key skills required for these roles.

```sql
WITH top_paying_jobs AS (

    SELECT 
        job_id,
        job_title,
        salary_year_avg as salary,
        name AS company
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON 
        job_postings_fact.company_id = company_dim.company_id
    WHERE 
        salary_year_avg IS NOT NULL AND 
        job_work_from_home IS TRUE AND 
        job_title_short = 'Data Analyst'
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
    )

SELECT
    COUNT(*) as skills_count,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON 
    top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY 
    skills
ORDER BY 
    skills_count DESC
```
The results from this query were exported to Excel in order to create the following columns chart that shows which are the skills related to the de best paying jobs.

<img width="422" height="247" alt="image" src="https://github.com/user-attachments/assets/59df291e-8410-4478-a680-51b16ecc28ff" />


#### 🔎 Conclusion

The results show that:
1. Eight out of ten of the best paying jobs include SQL as a skill to master.
2. Seven out of ten of the best paying jobs include Python as a skill to master.
3. Six out of ten of the best paying jobs include Tableau as a skill to master.
4. The next skills associated to the best paying jobs are R, Snowflake, Pandas and Excel.
This confirms that SQL, Python and Tableau are core skills for Data Analytics jobs, even on high positions (the ones with best paying jobs). 

### 3. In-Demand Skills for Data Analysts

To identify the most in-demand skills for Data Analyst roles, I reused the joins from the previous analysis and grouped the data by skill. I then counted the number of job postings that included each skill to measure its demand across the dataset.

```sql
SELECT 
    COUNT(*) AS demand_count,
    skills
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON 
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5
```
The results were exported to Excel to create a bar chart illustrating the most in-demand skills for Data Analyst roles.

<img width="437" height="275" alt="image" src="https://github.com/user-attachments/assets/c15faaf0-a2cc-41c8-a7aa-5ca9e80b459f" />


#### 🔎 Conclusion

The results shown from the analysis say that:

1. SQL is the skill with most appearande within all the job postings for Data Analyst roles. (93 000)
2. Excel is the second skill with most appeareace within all the job postings for Data Analyst roles. (67 000)
3. Python is the third skill with most appeareace within all the job postings for Data Analyst roles. (57 000)
4. Tableau and PowerBI are the next most demanded skills.

This confirms the already known typical path for a Data Analyst, which includes SQL, Excel, Python and PowerBI/Tableau as core skills for the roles. 

### 4. Top Paying Skills Analysis

For this query I kept the same filters from before (data analyst roles and salary not null) and the same joins, but this time I grouped the results by skill and average salary for those conditions, ordering the results from the highest salaries to the lowest. 

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS salary
FROM job_postings_fact 
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE job_title_short = 'Data Analyst' 
AND salary_year_avg IS NOT NULL 
GROUP BY skills
ORDER BY salary DESC 
LIMIT 10
```

#### 📊 Key Insights

- SVN was identified as the highest-paying skill in the dataset.
- Many of the top-paying skills are related to cloud infrastructure, software engineering, and machine learning rather than traditional analytics tools.
- The findings suggest that higher-paying Data Analyst roles increasingly require technical skills that bridge analytics, engineering, and data science.
- Developing expertise in programming, cloud technologies, and data engineering concepts may lead to access to higher-paying opportunities.

#### 🔎 Drill-Down Analysis

After identifying the top 10 highest-paying skills for Data Analyst roles, I performed a drill-down analysis to explore the job titles associated with these skills. This provided additional context beyond salary rankings and helped identify the types of roles driving higher compensation.

The following query retrieves all job postings associated with the top-paying skills, allowing for a deeper analysis of job title distribution and salary patterns.  

```sql
WITH top_skills AS (
    SELECT 
        skills_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg),0) AS salary
    FROM job_postings_fact 
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id 
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id 
    WHERE job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL 
    GROUP BY skills_dim.skill_id, skills
    ORDER BY salary DESC 
    LIMIT 10
)

SELECT 
    ts.skills,
    ts.salary,
    j.job_id,
    j.job_title
FROM top_skills ts
JOIN skills_job_dim sj
    ON sj.skill_id = ts.skill_id
JOIN job_postings_fact j
    ON j.job_id = sj.job_id
ORDER BY ts.salary DESC;

```

#### 🗂️ Background Dataset

The drill-down query returned more than 30,000 rows.
Due to the size of the dataset, the results were exported to Excel for further aggregation and visualization.
This allowed for a more flexible analysis of skill frequency and salary distribution at a granular level.

<img width="551" height="365" alt="image" src="https://github.com/user-attachments/assets/9525df5b-cdfa-4c06-834b-1b2631080012" />


#### 📈 Excel Analysis

### ⚙️Functions Used

**COUNTIF** was used to calculate the number of job postings associated with each skill.

```
=COUNTIF(top_skills[skills], A2)  
```

**MEDIAN** and **FILTER** were used to calculate the median salary associated with each skill.

```


=MEDIAN(FILTER(top_skills[salary], top_skills[skills]=D2))

```

<img width="200" height="160" alt="image" src="https://github.com/user-attachments/assets/03101759-ee5b-4c47-95bb-5dbe6ba27385" />  

### 📈 Visualization

The following combo chart was used to clearly illustrate the relationship between median salaries and skill demand across the top skills.

<img width="360" height="217" alt="image" src="https://github.com/user-attachments/assets/91a091da-ad01-4877-a9f1-7fb9059dacb7" />  

### 💡 Insights

SVN appears to be the highest-paying skill, with median salaries reaching up to $400K. However, it shows relatively low demand, with only around 1,000 job postings, indicating that it is a niche skill in the job market.

On the other hand, Terraform stands out as the most in-demand skill, with approximately 20,000 job postings and a median salary of around $150K, reflecting strong demand in cloud-related roles.

Overall, the chart highlights a clear trade-off between salary and demand: while SVN leads in compensation, it is highly specialized and less frequently required. In contrast, most other top skills cluster within a similar salary range of $100K–$200K, with Terraform emerging as the most widely requested skill among employers.


### 5. Most Optimal Skills to Learn

By combining salary data with skill frequency, I analyzed which skills offer both high earning potential and strong demand. Specifically, I calculated the average salary per skill and the number of job postings in which each skill appears, filtering out less relevant results by keeping only skills with more than 10 occurrences.

```sql
SELECT 
    COUNT(job_postings_fact.*) AS demand_count,
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
AND job_title_short = 'Data Analyst'
GROUP BY skills
HAVING COUNT(job_postings_fact.*) > 10
ORDER BY 
       avg_salary DESC,
       demand_count DESC
LIMIT 25
```

FINISH HERE
CONCLUSIONS

# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:



# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: 
2. **Skills for Top-Paying Jobs**: 
3. **Most In-Demand Skills**: 
4. **Skills with Higher Salaries**: 
5. **Optimal Skills for Job Market Value**: 

### Closing Thoughts
