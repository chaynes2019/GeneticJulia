# This is a comment!
# Goal: Write a simple evolutionary algorithm in Julia!
#= Multiline comment
  - Genomes: vector of numbers
  - Phenotype: sum of numbers
  - Selection: tournament
 =#

 using Random, Distributions

 # Configuration
 random_seed = 2
 pop_size = 1000
 generations = 1000
 genome_size = 5
 tournament_size = 8
 target_value = 100
 mut_prob = 0.02 # applied per-site
 
 max_genome_value = 200
 min_genome_value = -200
 
 
 
 Random.seed!(random_seed)
 mut_bernoulli = Bernoulli(mut_prob)
 mut_norm_dist = Normal(0.0, 1.0)
 
 # random = MersenneTwister(random_seed)
 
 # note the !, indicates that we're going to mutate the genome
 function mutate!(genome)
   for i=1:length(genome)
     if rand(mut_bernoulli)
        parityNumber = rand(mut_norm_dist) > 1 ? 1 : -1
        genome[i] = clamp(genome[i]+parityNumber*rand(mut_norm_dist), min_genome_value, max_genome_value)
     end
   end
 end
 
 function evaluate(genome)::Float64
   return sum([max_genome_value - abs(target_value - genome[i]) for i=1:length(genome)])
 end
 
 # Given list of scores, run tournament selection. Returns index of winner.
 function tourn_select(scores, tourn_size=8)
   participants = [rand(1:length(scores)) for i=1:tourn_size]
   champion = participants[1]
   for i=2:length(participants)
     challenger = participants[i]
     if scores[challenger] > scores[champion]
       champion = challenger
     end
   end
   return champion
 end
 
 # Initialize the population (to all zeroes)
 population = [[0.0 for k=1:genome_size] for i=1:pop_size]
 
 # Note - *Inclusive* range
 for gen = 1:generations
   println("====== Processing generation: $gen ======")
 
   # Evaluate the population
   scores = [evaluate(org) for org in population]
   # println("  Scores: $scores")
 
   # Selection promising individuals to reproduce
   next_population = [similar(population[i]) for i=1:pop_size] # Not sure what the best way to do this is...
   for i=1:length(next_population)
     parent_i = tourn_select(scores, tournament_size)
     next_population[i] = copy(population[parent_i]) # Copy is important, otherwise, it looks like you get a reference
   end
 
   # Mutate next population
   for i=1:length(next_population)
     mutate!(next_population[i])
     population[i] = copy(next_population[i]) # Update population with mutated offspring
   end
 
 end
 
 # Analyze the final population and print some information
 scores = [evaluate(org) for org in population]
 println("Final population: $population")
 println("Final scores: $scores")
 
 best = findmax(scores)
 best_org = population[best[2]]
 best_score = best[1]
 println("Best org: $best_org")
 println("  Score: $best_score")