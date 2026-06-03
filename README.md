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

### Background Dataset

The drill-down query returned more than 30,000 rows.
Due to the size of the dataset, the results were exported to Excel for further aggregation and visualization.
This allowed for a more flexible analysis of skill frequency and salary distribution at a granular level.

<img width="551" height="365" alt="image" src="https://github.com/user-attachments/assets/9525df5b-cdfa-4c06-834b-1b2631080012" />


### Excel Analysis



#### Functions Used

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




