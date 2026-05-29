/* 
What are the most in-demand skills for my role?
- I will focus on remote jobs for data analyst roles 
*/



SELECT 
    COUNT(job_postings_fact.job_id) AS demand_count,
    skills
FROM job_postings_fact
INNER JOIN skills_job_dim ON 
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON 
    skills_job_dim.skill_id = skills_dim.skill_id   
WHERE job_title_short = 'Data Analyst'
AND job_work_from_home IS TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
