# SQL Project Data Job Analysis
TO DO: Update the content of this later

## 4. Top Paying Skills Analysis

This query calculates the average salary for each skill by joining the job_postings_fact, skills_job_dim, and skills_dim tables.
It filters the dataset to include only Data Analyst roles with a valid salary value, and then computes the average salary per skill, returning the top 10 highest-paying skills.

```
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

### 📊 Key Insights

- SVN was identified as the highest-paying skill in the dataset.
- Many of the top-paying skills are related to cloud infrastructure, software engineering, and machine learning rather than traditional analytics tools.
- The findings suggest that higher-paying Data Analyst roles increasingly require technical skills that bridge analytics, engineering, and data science.
- Developing expertise in programming, cloud technologies, and data engineering concepts may lead to access to higher-paying opportunities.

### Drill-Down Analysis

After identifying the top 10 highest-paying skills for Data Analyst roles, I performed a drill-down analysis to explore the job titles associated with these skills. This provided additional context beyond salary rankings and helped identify the types of roles driving higher compensation.

The following query retrieves all job postings associated with the top-paying skills, allowing for a deeper analysis of job title distribution and salary patterns.  

```
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

Because the resulting dataset contained more than 30,000 rows, the data was exported to Excel for further aggregation and visualization. This enabled a more detailed analysis of job title distribution and salary patterns across the highest-paying skills.

### Excel Analysis

<img width="203" height="160" alt="image" src="https://github.com/user-attachments/assets/ba44b4f1-ef21-42bc-9ff0-9c7e504e92aa" />

#### Functions Used

**COUNTIF** was used to calculate the number of job postings associated with each skill.

```
=COUNTIF(top_skills[skills], A2)  
```

**MEDIAN** and **FILTER** were used to calculate the median salary associated with each skill.

```
=MEDIAN(FILTER(top_skills[salary], top_skills[skills]=D2))

```



