SELECT *
FROM CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations
--ORDER BY 3,4

--selecting data that going to be use

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidDeaths
ORDER BY 1,2

--total case vs total deaths

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%GERm%'
ORDER BY 1,2

--total case vs population
SELECT location,date,population,total_cases,(total_cases/population)*100 AS PercentPopulationInfected
FROM CovidDeaths
WHERE location LIKE '%GERm%'
ORDER BY 1,2

--countries with highest infection rate compared to population

SELECT location,population,MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC

--showing countries with highest death count per population
SELECT location,MAX(total_deaths) AS TotalDeathCounts
FROM CovidDeaths
WHERE continent IS NOT  NULL
GROUP BY location
ORDER BY TotalDeathCounts DESC

--comparing continents for total deaths
SELECT continent,MAX(total_deaths) AS TotalDeathCounts
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCounts DESC

--global numbers
SELECT SUM(new_cases) AS Total_Cases,SUM(new_deaths) AS Total_Deaths,CONCAT('%', SUM(new_deaths)/SUM(new_cases)*100) AS DeathPercentage
FROM CovidDeaths
ORDER BY 1,2

--total population vs vaccination 
--CTE
WITH PopvsVac(continent,location,date,population,RollingPeopleVaccinated,new_vaccinations)
AS(
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
 FROM CovidDeaths dea
 JOIN CovidVaccinations vac
 ON dea.date=vac.date AND dea.location=vac.location
 WHERE dea.continent IS NOT NULL
 )
 select *,(RollingPeopleVaccinated/population)*100 AS Ratio
 from PopvsVac


 --creating views for visualisation

 CREATE VIEW PercentPopulationVaccinated  AS
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
 FROM CovidDeaths dea
 JOIN CovidVaccinations vac
 ON dea.date=vac.date AND dea.location=vac.location
 WHERE dea.continent IS NOT NULL

 SELECT *
 FROM PercentPopulationVaccinated 
