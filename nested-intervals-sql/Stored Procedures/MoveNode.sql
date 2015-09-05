CREATE PROCEDURE [dbo].[MoveNode] (
	@nodeId BIGINT,
	@newParentNodeId BIGINT
	--@newOlderSiblingId BIGINT
)
AS
	/*
	DECLARE @newYoungerSibling_nv BIGINT, @newYoungerSibling_dv BIGINT

	SELECT TOP 1
		@newYoungerSibling_nv = nos.[snv],
		@newYoungerSibling_dv = nos.[sdv]
	FROM [Node] as nos
	WHERE nos.[node_id] = @newOlderSiblingId

	-- first we make room. update all younger siblings (and their children)?

	-- then update node itself

	-- and then all of node's children

	-- amd finally all of nodes younger siblings from before the move
	*/
RETURN
