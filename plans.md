Plans:

Combat needs enough nuance that the right answer isn't always "this one that has high power"
I don't think RPS via different damage types is the way to go
Right now I'm thinking every part should have 
    HP or Shields (contributed to the whole)
    Defense
        Average of all parts, 0-10
        5% removed per tier for a max of 50% reduction
    Durability (used per action) 
    Speed (How long until next action)
    Cooldown (How long until part is usable again)
    Damage (How much hurty)
    Hits (How many hurty)
    Accuracy (hit chance)
        tiers of accuracy
        5 = always hit
        4 = 90% chance
        3 = 80% chance
        2 = 70% chance
        1 = 60% chance
        0 = 50% chance

In practice, no part has all three of Spd, Cooldown, Durability, and Dmg in spades
High damage and high speed, long cooldown and low durability (rocket launcher type thing)

How do we randomize parts?
    Option A: Archetypical parts that share names and sprites, assign values in a particular order

Honestly option A makes the most sense. If the sprite is a rocket launcher but works like a machine gun, that's no good.

Speed and Cooldown should be small values, 1-5 range, expressed with dots.
Defeating an enemy should take about 10 ticks.
    If an enemy had 50 health, then 5 damage every turn

Should shields recharge between rounds? I think so, but not durability
    The rationale is that you should be able to survive a near equal match without being screwed in the next round, but you still need to swap parts to stay functioning.


Okay, combat step--------------
    Players selects option from all 5 parts
        Need to get an action name from each part for display
        A global "use" function defined on each part
            contains stats like target, damage, hits, accuracy, and speed
            adds object to a player specific queue and is executed in order
        Opponent should have a similar queue with the same properties
        An external controller will execute and advance both queues
        

        
09/23 refactoring plans

Problem: Opponent and Player are taking slightly different routes to accomplish the same things. Abstracting the queues in passive voice (opponent receives instead of player does) isn't helping anything either.

Solutions:
Encapsulate functions better and make them take the robots as parameters
Combat manager takes details and asks for actions, rather than relying on the player object to know when to supply actions.

Break down phases more concretely and organize them accordingly
    1: Process action queues
    2: Check for Ready robots
    3: Request actions
    4: Add actions

