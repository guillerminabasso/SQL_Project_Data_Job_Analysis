/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/




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


/* Conclusions:
- SQL is the most in-demand skill for Data Analyst roles, appearing in over 93,000 job postings.
- Excel is the second most in-demand skill, appearing in more than 67,000 job postings.
- Python, Tableau, and Power BI are also among the most frequently requested skills for Data Analyst positions.
*/