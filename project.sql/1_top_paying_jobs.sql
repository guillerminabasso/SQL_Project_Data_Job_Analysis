/* Looking for the top-paying jobs for data analyst roles
- Identify the top 10 highest-paying data analyst roles that are available remotely
- Focus on job postings with specified salaries (remove nulls)
- Why? Highlight the top-paying opportunities for data analysts 
- What are the companies of these 10 best-paying jobs? */

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

/* First conclusions:
- Best-paying remote jobs come from american companies
- I would say the first job with a salary of $650.000 might be an outlier
(salary is too high compared to the other 9 offers. */


