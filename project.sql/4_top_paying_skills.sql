/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and 
    helps identify the most financially rewarding skills to acquire or improve
*/


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

/*

Conclusions:

- The highest-paying skill identified in the dataset is SVN (version control & collaboration tools, similar to Git).
- Other high-paying skills include Solidity (blockchain programming), Couchbase (NoSQL databases), DataRobot (AutoML platforms), Go (Golang), MXNet (deep learning framework), dplyr (R data manipulation), VMware (virtualization tools), Terraform (cloud infrastructure), and Twilio (communication APIs).
- While many of these tools were unfamiliar at first, exploring them reveals an important trend: modern data roles are increasingly moving beyond traditional analytics tools like SQL, Excel, and Power BI.
-These skills highlight three key patterns:
    - Modern data stacks are becoming more complex and cloud-based, involving APIs, distributed systems, and infrastructure tools.
    - Higher-paying roles often sit at the intersection of analytics, engineering, and data science, such as Analytics Engineer, Product Data Analyst, and Data Engineer.
    - Data analytics is becoming more technical and code-driven, requiring stronger software engineering and system-level understanding.
- Overall, this analysis shows that to access higher-paying data roles, it is increasingly important to go beyond traditional analytics tools and develop skills in programming, cloud technologies, and data engineering concepts alongside SQL, Python, and Power BI.
*/

/*

After identifying the top 10 highest-paying skills for Data Analyst roles using average salary aggregation, I performed a deeper drill-down analysis to examine the job titles associated with each of these skills.
This allowed me to move beyond a high-level salary ranking and gain more context about the types of roles that are driving these higher salaries.*/


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

/*
Due to the high level of granularity in the drill-down dataset (over 30,000 rows), I exported the results for further analysis in Excel. This allowed me to aggregate and visualize the data more effectively, focusing on patterns such as job title distribution and salary concentration across the top-paying skills.
*/