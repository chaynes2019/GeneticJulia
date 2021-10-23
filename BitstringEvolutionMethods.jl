module BitstringEvolution

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

export generatePopulation, fitness, lociAdditionFitness, getIndexableFitnesses, biologicalTourney
export averageFitness, mutate!

end