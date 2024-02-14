#[starknet::interface]
trait IGame<TContractState> {
    fn start(self: @TContractState);
    fn move(self: @TContractState, direction: dojo_starter::models::moves::Direction);
}

#[dojo::contract]
mod game {
    use super::IGame;
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{
        position::{Position, Vec2}, moves::{Moves, Direction}, player::{Player}
    };

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Moved: Moved,
    }

    // declaring custom event struct
    #[derive(Drop, starknet::Event)]
    struct Moved {
        player: ContractAddress,
        direction: Direction
    }

    fn next_position(mut position: Position, direction: Direction) -> Position {
        match direction {
            Direction::None => { return position; },
            Direction::Left => { position.vec.x -= 1; },
            Direction::Right => { position.vec.x += 1; },
            Direction::Up => { position.vec.y -= 1; },
            Direction::Down => { position.vec.y += 1; },
        };
        position
    }

    // impl: implement functions specified in trait
    #[abi(embed_v0)]
    impl GameImpl of IGame<ContractState> {
        // ContractState is defined by system decorator expansion
        fn start(self: @ContractState) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Retrieve the player's current position from the world.
            let position = get!(world, player, (Position));

            // Retrieve the player's move data, e.g., how many moves they have left.
            let moves = get!(world, player, (Moves));

            // Get the npc 
            // Update the world state with the new data.
            // 1. Set players moves to 10
            // 2. Move the player's position 100 units in both the x and y direction.
            set!(
                world,
                (
                    Moves { player, last_direction: Direction::None },
                    Player {
                        player_id: player,
                        health: 100,
                        position: Position { player, vec: Vec2 { x: 10, y: 10 } }
                    },
                )
            );
        }

        // Implementation of the move function for the ContractState struct.
        fn move(self: @ContractState, direction: Direction) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let (mut player_model, mut moves) = get!(world, player, (Player, Moves));

            let next = next_position(player_model.position, direction);

            player_model.position = next;

            set!(world, (moves, player_model));

            emit!(world, Moved { player, direction });
        // Deduct one from the player's remaining moves.
        // moves.remaining -= 1;

        // Update the last direction the player moved in.
        // moves.last_direction = direction;

        // Calculate the player's next position based on the provided direction.
        // let next = next_position(position, direction);

        // Update the world state with the new moves data and position.
        // set!(world, (moves, next));

        // Emit an event to the world to notify about the player's move.
        // emit!(world, Moved { player, direction });
        }
    }
}
