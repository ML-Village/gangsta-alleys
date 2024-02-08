/* Autogenerated file. Do not edit manually. */

import { defineComponent, Type as RecsType, World } from "@dojoengine/recs";

export type ContractComponents = Awaited<
    ReturnType<typeof defineContractComponents>
>;

export function defineContractComponents(world: World) {
	return {
		Moves: (() => {
			return defineComponent(
			world,
			{ player: RecsType.BigInt, remaining: RecsType.Number, last_direction: RecsType.Number },
			{
				metadata: {
				name: "Moves",
				types: ["contractaddress","u8","enum"],
				customTypes: ["Direction"],
				},
			}
			);
		})(),
		Position: (() => {
			return defineComponent(
			world,
			{ player: RecsType.BigInt, vec: { x: RecsType.Number, y: RecsType.Number } },
			{
				metadata: {
				name: "Position",
				types: ["contractaddress","u32","u32"],
				customTypes: ["Vec2"],
				},
			}
			);
		})(),
	};
}
