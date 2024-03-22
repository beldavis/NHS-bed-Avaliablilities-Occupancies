
-- The next 2 queries is to see that my data was imported correctly

Select TOP 2 *
FROM PortfolioProject..CovidDeaths
order by 3,4

Select TOP 2  *
FROM PortfolioProject..CovidVaccinations
order by 3,4

-- The next query will select the data I will be using.

Select 
	Location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY Location, date


-- Looking at Total cases vs Total deaths
-- I will be looking at the what dates in time were the death percentage rate was high, in the UK.

Select 
	Location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'United Kingdom' AND
continent IS NOT NULL
ORDER BY DeathPercentage DESC


-- The month of April,May and June seemed like the most devasting time. The rate sort of climbed down as the months went by
-- Recent times, (September 2022) the death rates have decreased drastically. it isn't upto 1%

-- Now I will be looking at the Total cases vs Population

Select 
	Location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 as Population_Percentage_Rate_Of_Covid
FROM PortfolioProject..CovidDeaths
WHERE location = 'United Kingdom' AND
continent IS NOT NULL
ORDER BY Population_Percentage_Rate_Of_Covid DESC

-- It is amazing to know that as at September, 35% of the population in UK has covid. It will be intresting to see what happens this winter
-- The rates are increasing. The rate at which people catch covid is alarming. From our previous query I found out that the death rates are reducing,
-- but the infection rate is on the rise. 

-- Looking at countries with Highest Infection Rate compared to Population

Select
	Location,
	population,
	MAX(total_cases) as Highest_Infection_Count,
	Max((total_cases/population)*100) as Highest_Infection_Rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Highest_Infection_Rate DESC


-- Looking at continents with Highest Infection Rate compared to Population

Select 
	continent,
	SUM(population) as Total_population,
	MAX(total_cases) as Highest_Infection_Count,
	(Max(total_cases) / sum(population))*100 as Highest_Infection_Rate) as Highest_Infection_Rate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent --population
ORDER BY Highest_Infection_Rate DESC

-- CYprus is greatly hit when you consider the percentage, same as Faeroe Islands. However we need to consider the number of infection count
-- is not much compared to other countries. Europe has the highest infection rate. Africa wasn't so hit considering they are the second most
-- populous continents. We should also consider the fact that how available were the test equipments. 

-- Let us look at the most populous countries and continent in the world and see how covid has affected them.

-- Now I will be Looking at countries and continents with Highest deaths percentage rates

Select 
	location,
	MAX(population) as Total_population,
	MAX(total_cases) as Total_cases,
	MAX(CONVERT(INT,total_deaths)) AS Total_deaths,
	(MAX(CONVERT(INT,total_deaths)) / MAX(total_cases))*100 as Death_rate_to_cases,
	(MAX(CONVERT(INT,total_deaths)) / MAX(population))*100 as Death_rate_to_population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Death_rate_to_population desc

Select 
	continent,
	MAX(population) as Total_population,
	MAX(total_cases) as Total_cases,
	MAX(CONVERT(INT,total_deaths)) AS Total_deaths,
	(MAX(CONVERT(INT,total_deaths)) / MAX(total_cases))*100 as Death_rate_to_cases,
	(MAX(CONVERT(INT,total_deaths)) / SUM(population))*100 as Death_rate_to_population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 desc


-- Africa didn't have much cases but the death rates were relatively high. This could be as a result of lack of medical 
-- facilities and infastructures, or the vaccine not getting out to them quickly

-- Global Daily Numbers (Death rates,compared to both case and population)

Select 
	date,
	continent,
	SUM(population) as Total_population,
	SUM(total_cases) as Total_cases,
	SUM(CONVERT(INT,total_deaths)) AS Total_deaths,
	(SUM(CONVERT(INT,total_deaths)) / SUM(total_cases))*100 as Death_rate_to_cases,
	(SUM(CONVERT(INT,total_deaths)) / SUM(population))*100 as Death_rate_to_population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date, continent
ORDER BY date desc, Death_rate_to_cases desc


-- LOOKING AT POPULATION VS VACCINATIONS

-- Let me have  view of our table.

SELECT TOP 2 *
FROM PortfolioProject..CovidVaccinations

SELECT TOP 2 *
FROM PortfolioProject..CovidDeaths

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL --and vac.location = 'United Kingdom'
ORDER BY 2,3 desc

-- I will try to add a rolling count

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location) as Sum_of_Vaccinations
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3 

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location
													ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3 

-- Total Vaccination vs Total Population

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location
													ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL --and location = 'United Kingdom'
ORDER BY 2,3 

-- I am trying to calculate the rolling percentage and this can be done in 3 ways
-- We need to use a CTE 

WITH PopvsVac 
	(continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated) as
(
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location
													ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL --and location = 'United Kingdom'
--ORDER BY 2,3
)
SELECT 
	*,
	(Rolling_People_Vaccinated / population)* 100 AS Rolling_Percentage
FROM PopvsVac

-- TEMP TABLE
DROP TABLE IF exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location
													ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL --and location = 'United Kingdom'
--ORDER BY 2,3

SELECT 
	*,
	(Rolling_People_Vaccinated / population)* 100 AS Rolling_Percentage
FROM #PercentPopulationVaccinated


-- Creating VIEW to store data for later

CREATE VIEW PercentPopulationVaccinated as
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location
													ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL --and location = 'United Kingdom'


Select *
FROM [PortfolioProject].[dbo].[PercentPopulationVaccinated]

