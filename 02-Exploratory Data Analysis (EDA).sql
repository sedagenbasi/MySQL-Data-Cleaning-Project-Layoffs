-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off =1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
group by company
order by 2 DESC;

SELECT min(`date`), max(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
group by industry
order by 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
group by country
order by 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by YEAR(`date`)
order by 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
group by stage
order by 2 DESC;

SELECT substring(`date`, 1,7) AS `MONTH`, sum(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`, 1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT substring(`date`, 1,7) AS `MONTH`, sum(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`, 1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by company,YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by company,YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
dense_rank() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5 ;



