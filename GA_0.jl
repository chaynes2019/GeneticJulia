using IterTools, Random, Distributions

# This is a bitstring genetic algorithm!

geneticAlphabet = [0,1]
genomeLength = 10
initialPopulationSize = 1000
desiredGenerations = 10
global mutationProb = 0.0003125
randomSeed = 53
Random.seed!(randomSeed)

mutationBernoulli = Bernoulli(mutationProb)


# Don't unnecessarily assign variables: only after working :)
function generatePopulation(alphabet, genomeLength, populationSize)
    return [[0 for i=1:genomeLength] for k=1:populationSize]
end

function fitness(fitnessFunc, genome, environment = nothing)
    return fitnessFunc(genome)
end

#Let's create some wackadoodle fitness schemes!

function lociAdditionFitness(genome)
    fitness = reduce(+, genome)
    return fitness
end

function getIndexableFitnesses(population, fitnessFunc)
    fitnesses = [fitness(fitnessFunc,population[i]) for i=1:length(population)]
    return fitnesses
end

function biologicalTourney(population, fitnessFunc, tourneySize = 8)
    fitness = getIndexableFitnesses(population, fitnessFunc)
    contenders = [rand(1:length(population)) for i=1:tourneySize]
    champion = contenders[1]
    for i=2:tourneySize
        if fitness[contenders[i]] > fitness[champion]
            champion = contenders[i]
        end
    end
    return population[champion]
end

function averageFitness(population, fitnessFunc)
    fitness = getIndexableFitnesses(population, fitnessFunc)
    if(length(fitness) != 0)
        avgFitness = reduce(+,fitness)/length(fitness)
    else
        avgFitness = nothing
        print("You have to have some fitness before you can take an average!")
    end
    return avgFitness
end

function mutate!(genome)
    l = length(geneticAlphabet)
    newGenome = [0 for i = 1:genomeLength]
    for i=1:genomeLength
        mutationNeighbors = [gene for gene in geneticAlphabet if gene != genome[i]]
        newGenome[i] = rand(mutationBernoulli) ? mutationNeighbors[rand(1:l-1)] : genome[i]
    end
    return newGenome
end

#What is the relationship between convergence time and mutation rate? It seems like too slow of a mutation rate and you'll take a super-long time; if too fast of a mutation rate, you'll never settle down on an optimum. Does it have to do with the gradient of the optimum and how evolvable the landscape is near the optimum?
#Why is it that mutant phenotypes are often a result of mutation that occurred in a parent? Obviously, it has to do with the fact that mutation seems to have greatest effect on phenotype when it affects development. So I guess, what's the explanation behind that?

initialPopulation = generatePopulation(geneticAlphabet,genomeLength,initialPopulationSize)
initAvgFitness = averageFitness(initialPopulation, lociAdditionFitness)
pop = initialPopulation
print("Initial Average Fitness: $initAvgFitness \n")
for gen = 1:desiredGenerations
    println("====== Processing generation: $gen ======")
    nextPopulation = [mutate!(biologicalTourney(pop,lociAdditionFitness)) for i=1:length(pop)]
    global pop = nextPopulation
end

maxFitness = genomeLength
finalFitness = averageFitness(pop, lociAdditionFitness)
print("Theoretical Max Fitness: $maxFitness \n")
print("Final Achieved Fitness:  $finalFitness \n")

