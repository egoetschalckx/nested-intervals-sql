CREATE PROCEDURE DeleteRandomNode(
	@deletedNodeId BIGINT OUTPUT
) 
AS
	SET NOCOUNT ON
	DECLARE @randomNodeId BIGINT

	-- query for a random node in the tree, but exclude the root node
	SELECT TOP 1 @randomNodeId = [node_id] FROM [Node] WHERE [node_id] <> 0 ORDER BY NEWID()

	EXECUTE DeleteNode @randomNodeId

	SET @deletedNodeId = @randomNodeId
RETURN
