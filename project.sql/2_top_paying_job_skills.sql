/* What are the skills required for the top-paying data analyst jobs?
- Use the top 10 highest-paying data analyst jobs from first query
- Add the specific skills required for this roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
helping job seekers understand which skills to develop that align with top salaries
*/

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



/* Conclusions:

- The most demanded skill for the 10 best-paying jobs is SQL
with more than 8 out of 10 job offers demanding for it
- The second most demanded skill is Python with 7 out of 10
job offers demanding for it
- The third most demanded skill is tableu with 6 out of 10 
job offers demanding for it
- r, snowflake, pandas, excel are the next most demanded
skills with 3 job offers demanding for them

The results of this query were exported in a csv file
ir order to look at them in Excel and building a chart
to better ilustrate the results */


