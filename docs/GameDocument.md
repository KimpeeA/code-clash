# Game Document

## Overview

Code-Clash is a code-based action game that combines programming and combat.
Players control their characters entirely through JavaScript code, writing instructions that determine how their character moves, attacks, and reacts to enemies in a 2D battle environment.

Each level presents a unique challenge, an enemy opponent with increasing difficulty and different combat behaviors.
The player’s goal is to write smarter and more efficient code to outmaneuver and defeat the opposing opponent.

## Game Details

When the player enters a level, a **battle arena** is displayed.
Both the player’s character and the enemy begin in an **idle** state - standing still, waiting for the simulation to start.

### Starting the Simulation

The **game simulation** begins when the player runs their JavaScript code.
As soon as the player executes their code, the following happens:

1. The current simulation resets - both characters return to their initial idle states and positions, as if the level was just loaded.
2. The player’s script is then executed, and the simulation begins.
3. The character starts performing actions and movements based on the code’s instructions, while the enemy follows its predefined behavior.

### Deterministic Simulation

Each simulation is **deterministic**.
This means that the enemy’s movements, actions, and timing are always identical every time the simulation restarts.
This ensures that player results are entirely based on their code - not on random chance.

### Code Execution and Character Behavior

The simulation continues for as long as the player’s code is executing.
Once the player’s script finishes running:

- The character stops receiving new instructions and remains idle.
- The enemy continues to act according to its behavior pattern.
- The simulation continues in real time until one side is defeated.

### Ending the Simulation

The simulation ends when either the player’s character or the enemy’s health reaches zero.


## Levels

The game has many different levels, each level has enemy.

the higher the level, the more harder the enemy is.

All levels are locked, except for 1st level. the current level must be complete then the next level will be unlocked

## Character Instruction System

Imagine a character inside a 2D virtual world. It can’t do anything on its own - it only acts when **you** give it an instruction.
These instructions represent anything that can make the character interact with the world, such as **movement** or **actions**.

You can give the character an instruction at any time, as long as it’s something the character is capable of doing.
A **movement instruction** controls how the character moves - like walking, running, facing left or right, idling (stopping), jumping, or dashing.
An **action instruction** tells the character to *do* something - like attacking, healing, or blocking (parrying).

When you give the character a **walk** instruction, it starts walking in the direction it’s currently facing.
It will keep walking indefinitely until you give another instruction.
If it’s facing left, it walks left; if it’s facing right, it walks right.

## For these examples, let’s assume the character is a Swordsman.

### Movement Instruction Scenarios

* The character is walking left. After some time, you tell it to **face right** - it stops, turns to the right, and starts walking again. Now it’s walking right.
* The character is walking right. After some time, you tell it to **jump** - it jumps toward the right, and after landing, continues walking.
* The character is walking right. After some time, you tell it to **dash** - it quickly dashes right, and once the dash ends, resumes walking.

### Action Instruction Scenario

* The character is walking right. After some time, you tell it to **slash** - it performs a slash toward the right, and once the attack ends, it continues walking.

### **Failed** Instructions

The instruction can’t be executed right now because the character’s current state doesn’t allow it.
It’s not invalid, but it’s not possible at that moment.

For example, if the character is walking right and you give it a **dash** instruction, it will dash to the right.
But if you try to give it a **jump** instruction *while it’s still dashing*, it can’t jump yet - so that instruction fails.
The character ignores the failed instruction and continues dashing.
Once it stops dashing and resumes walking, you can successfully give it the **jump** instruction again.

If the character is falling and you give it a **walk** instruction, it can’t walk while falling, so that instruction fails.
If the character can **Dash** while falling, giving a **Dash** instruction will succeed, and the character will dash in the direction it’s facing while falling.

### **Ignored** Instructions

The instruction doesn’t make sense or has no effect.

For example, If the character is already walking right, and you give another walk right, it’s ignored (no change).
But if you give walk left, that’s not ignored - it’s actually a new movement direction instruction that might interrupt or replace the old one.

> *"If the character is already walking, it can’t walk in the opposite direction at the same time."*, wait, how do we handle this?

### **Success** Instructions

When an instruction is successful, the character performs it and changes its state accordingly.

### Instructions that **Failed** or were **Ignored**

When an instruction fails or is ignored, it is discarded, and the character will continue with what its doing, until you give it a new instruction.

#### Summary

An instruction can either **succeed** (the character performs it), **fail** (the character can’t do it at that time), or be **ignored** (the instruction has no effect).

## Technical Details

A **States** is a current state of the character, which can be **Idle**, **Walking**, **Running**, **Jumping**, **Dashing**, **Falling**, or **Attacking**.

A **State** can be changed by giving the character an instruction, which make the state change to the new state.
Giving an instruction while the character is in a certain state can either succeed, fail, or be ignored.

### The Instruction Sources

Instructions can come from different sources - anything capable of sending commands to the character.

In this system, there are two main instruction sources:

Perfect - you’ve got the structure figured out already, and you’re just missing how to **frame and introduce** it in the document.

Here’s how you can present that section clearly and professionally, while staying consistent with your "instruction system" style.

## Sources of Instruction

Instructions can come from different sources - anything capable of sending commands to the character.
In this system, there are two main instruction sources:

### 1. **Code (Player-Controlled Script)**

These instructions come from JavaScript code, written by the player.
Each available instruction (such as `walk()`, `face_left()`, `face_right()`, `dash()`, or `attack()`) is exposed as a function or method in JavaScript.
When the script calls one of these functions, the JS engine passes the request into the game’s **Instruction System**, which then validates and executes it depending on the character’s current state.

In short, the **code source** is how a player gives precise, programmable control to the character.

Each of these calls translates into an internal instruction that’s handled by the movement/action system.

#### Details

The player writes code that calls functions like `walk()`, `face_left()`, `dash()`, or `attack()`.

For example:

```js
walk();
dash();
attack();
stop();
```

Calling a function like `walk()`, `dash()`, or `attack()` sends a corresponding instruction to the character.
The Instruction System checks the current state and decides whether the instruction can execute immediately, fail, or be ignored.

For example:

- `walk()` -> starts walking if idle.
- `dash()` -> executes if walking or idle, otherwise may fail.
- `attack()` -> executes while idle or walking if allowed.

##### The issue

There is an issue, since the javscript engine will execute the code sequentially, if the player calls `walk()`, `dash()`, and `attack()` in a row, the character will only execute the first instruction, and other instructions will be ignored or failed, depending on the character's state.

To handle this, we have 2 options.
1. **Synchronous: Queue the instructions**: The system can queue the instructions and execute them one by one, allowing the character to perform each action in sequence.
2. **Asynchronous: Expose a helper functions**: The system can expose helper functions that allow the player to wait for the previous instruction to complete before issuing a new one, ensuring that the character can perform each action without interruption.

The 1st option is not viable for as the player might want to do something first instead of blocking, so we’ll go with the 2nd option.

An example of how the player can use the helper functions:

Almost any character movement or action state can take time to complete, so the player can use `wait_for` helper function to wait for the previous instruction to complete before issuing a new one.

The `walk()` will take some time to complete, since the character try to walk until it reaches the maximum walking speed.
The `dash()` will take some time to complete, since the character will dash for a short duration.
The `attack()` will take some time to complete, since the character will perform an attack animation.
The `stop()` will take some time to complete, since the character will stop moving and return to idle state.


Calling `wait_for` will pause the execution of the code until the previous instruction is completed, allowing the player to issue a new instruction only after the previous one is done.

For example:

```js
walk();
wait_for(); // Wait for the walk to complete
dash(); // Now the character is walking at full speed, and we can dash
attack(); // after calling `dash()`, we immediately call `attack()`, but we need to wait for the dash to complete, so the `attack()` instruction will failed.
wait_for(); // Wait for the dash to complete
stop(); // Now we can stop the character, since the dash is completed
// any later instruction can be execute.
```

### 2. **AI (Bot or Behavior Tree)**

The AI also sends instructions to the character, but instead of coming from player code, they’re generated by the AI logic - for example, through a behavior tree, decision node, or utility system.

The process is the same:
the AI issues an instruction like "move toward target" or "attack" and the **Instruction System** decides whether it can be executed, failed, or ignored.

# Thoughts

> The following texts are just thoughts and ideas, not part of the final document.

The instruction sources, the The Character Instruction System implementated in the game can be designed as similar to how web APIs work, where the source of the instruction is the one that sends the request, and the system handles it based on the current state of the character.

The character controller will be implemented as a independent module that can be used by instruction sources, such as the player code or AI; if possible or in future design, the character controller can be used by other new sources as well like an actual player keyboard input.

