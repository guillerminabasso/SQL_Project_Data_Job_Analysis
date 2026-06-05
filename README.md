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
1. The highest reported salary is $650,000, substantially higher than the second-highest salary of $400,000. This large gap suggests that further investigation may be needed to determine whether the top value represents an outlier or a legitimate high-paying position.
2. Among the top 10 highest-paying remote Data Analyst roles, the highest-paid position is located in India, while the remaining nine positions are associated with companies based in the United States. This highlights the strong presence of U.S.-based opportunities within the highest salary range.
3. The companies offering these top-paying positions operate across a variety of industries, suggesting that high compensation for Data Analysts is not limited to a single sector but can be found in diverse business domains.


#### 🔎 Drill-down Analysis

To further investigate the highest-paying role identified in the initial query, a detailed dataset of remote Data Analyst job postings was extracted by removing the LIMIT 10 clause and focusing on raw salary values without joins or aggregations.

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

The salary distribution was examined using the Interquartile Range (IQR) method to determine whether the highest salary identified in the SQL query ($650,000) should be considered an extreme anomaly.

The analysis identified 26 statistical outliers, most of which were concentrated in the upper end of the salary distribution. This indicates that many of the highest-paying roles returned by the SQL ranking fall outside the typical salary range for remote Data Analyst positions.

While these salaries are statistically classified as outliers, they do not necessarily represent data errors. Instead, they appear to reflect a small subset of exceptionally well-compensated positions that exist within a highly right-skewed salary distribution. Consequently, the $650,000 salary can be interpreted as an extreme but plausible market observation rather than clear evidence of an invalid record. 

<img width="535" height="351" alt="image" src="https://github.com/user-attachments/assets/ce679f5e-3cdb-44f4-8f77-30855c06ffd3" />



#### 🔎 Conclusion (Histogram + Outliers Interpretation)

The histogram shows that the majority of Data Analyst salaries are concentrated between approximately $25,000 and $125,000, indicating a strong central tendency within this range. This reflects a relatively consistent salary band for most roles in the dataset.

However, the distribution is highly right-skewed, with a small number of salaries extending beyond $600,000. These extreme values are rare and have limited visual influence on the histogram due to their low frequency, which compresses the visibility of the upper tail.

The IQR analysis confirms that these extreme values are statistically classified as outliers. However, this classification does not necessarily indicate data errors. Instead, they likely represent highly specialized, senior, or exceptional roles that command significantly higher compensation than the typical market range.

Overall, the salary distribution follows a common labor market pattern: a dense concentration of standard roles with a long right tail representing a small number of high-paying niche positions.


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

<img width="421" height="245" alt="image" src="https://github.com/user-attachments/assets/c9ca7d7b-183b-4d5a-8dfb-7f80de3e3708" />



#### 🔎 Conclusion

The results show the most frequently occurring skills across the 10 highest-paying Data Analyst roles:

- **SQL** appears in 8 out of 10 job postings, making it the most common skill among top-paying roles.
- **Python** appears in 7 out of 10 postings, highlighting its strong relevance for high-compensation positions.
- **Tableau** appears in 6 out of 10 postings, indicating continued importance of data visualization tools at higher salary levels.
- Other frequently appearing skills include R, Snowflake, Pandas, and Excel, which reflect a combination of statistical, cloud, and analytical toolsets.

Overall, the results suggest that SQL, Python, and Tableau form a core skill set consistently associated with high-paying Data Analyst positions. However, this analysis reflects skill frequency within a small subset of top-paying roles, rather than universal job requirements across the entire market.

### 3. In-Demand Skills for Data Analysts

To identify the most in-demand skills for Data Analyst roles, I reused the joins from the previous analysis and grouped the data by skill. Unlike the previous sections, which focused only on remote positions, this analysis considers the entire dataset of job postings.

I then counted the number of job postings that included each skill in order to measure its overall demand across the market.

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

The analysis of skill demand across Data Analyst job postings highlights the most frequently requested technical skills in the dataset.

- **SQL** is the most in-demand skill, appearing in approximately 93,000 job postings, making it the dominant requirement for Data Analyst roles.
- **Excel** ranks second, with around 67,000 mentions, reflecting its continued importance for data manipulation and reporting tasks.
- **Python** is the third most requested skill, appearing in approximately 57,000 postings, highlighting its relevance for more advanced analytics and automation.
- **Tableau** and **Power BI** follow as key data visualization tools frequently required by employers.

Overall, the results confirm that Data Analyst roles are primarily centered around SQL, Excel, Python, and BI tools (Tableau / Power BI), reinforcing a standard and widely recognized technical skill stack in the field.

### 4. Top Paying Skills Analysis

For this analysis, I used the same filters as previous sections (Data Analyst roles with non-null salaries) and calculated the average salary associated with each skill. Unlike earlier analyses focused on job-level insights, this approach aggregates salary data at the skill level to identify which skills tend to appear in higher-paying roles.

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

- SVN appears as the highest-paying skill based on average salary within the dataset, although it is associated with a relatively small number of job postings.
- Several of the top-paying skills are related to cloud infrastructure, engineering, and machine learning rather than traditional data analysis tools.
- This suggests that higher compensation is often associated with hybrid roles that combine analytics with engineering or data infrastructure responsibilities.
- As a result, expanding into programming, cloud technologies, and data engineering concepts may increase access to higher-paying opportunities.

#### 🔎 Drill-Down Analysis

To provide additional context, a second query was executed to link the top-paying skills back to individual job postings. This allows for a more granular understanding of job titles and salary distributions associated with each skill.

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

The resulting dataset was exported to Excel due to its size (~30,000 rows), enabling further aggregation and visualization.

<img width="551" height="365" alt="image" src="https://github.com/user-attachments/assets/9525df5b-cdfa-4c06-834b-1b2631080012" />


#### 📈 Excel Analysis

Two complementary metrics were calculated:

Skill frequency using COUNTIF to measure how often each skill appears across job postings.
Median salary per skill using MEDIAN(FILTER(...)) to reduce the influence of extreme values and better represent typical compensation levels.


<img width="200" height="160" alt="image" src="https://github.com/user-attachments/assets/03101759-ee5b-4c47-95bb-5dbe6ba27385" />  

### 📈 Visualization

The following combo chart was used to clearly illustrate the relationship between median salaries and skill demand across the top skills.

<img width="360" height="217" alt="image" src="https://github.com/user-attachments/assets/91a091da-ad01-4877-a9f1-7fb9059dacb7" />  

### 💡 Insights

The combined analysis reveals a clear distinction between salary and demand:

- **SVN** shows the highest median salary (~$400K), but appears in a limited number of job postings, suggesting a highly specialized niche skill.
- **Terraform** stands out as the most in-demand skill, with approximately 20,000 job postings and a median salary around $150K, indicating strong relevance in cloud-related roles.
- Most other top skills cluster between $100K and $200K, showing relatively stable compensation across widely used technologies.

Overall, the results highlight a trade-off between compensation and market demand, where niche skills tend to offer higher salaries but lower frequency, while widely adopted tools provide more consistent employment opportunities.


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

<img width="589" height="311" alt="image" src="https://github.com/user-attachments/assets/f3a86ec3-6fab-4cf3-a23b-5929947ba5d3" />


### 💡 Insights

The most optimal skills are those that balance both high demand and competitive salaries. This relationship is clearly visible in the chart, where several technologies form a cluster of strong performers across both dimensions.

Skills such as Spark, Snowflake, Hadoop, Databricks, and GCP stand out by combining relatively high average salaries (approximately $110K–$130K range) with strong demand (roughly 100–250 job postings).

Rather than a single dominant skill, the results suggest a group of “high-opportunity” technologies, primarily focused on data engineering and cloud infrastructure.

Overall, this highlights a clear trend: the most valuable skills in the Data Analyst market are increasingly aligned with big data processing and cloud ecosystems, rather than traditional analytics tools alone.



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
