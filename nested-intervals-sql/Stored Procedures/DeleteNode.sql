CREATE PROCEDURE DeleteNode(
	@nodeId BIGINT
) 
AS
	SET NOCOUNT ON

	-- no orphans
	DELETE 
	FROM [Node]
	WHERE [node_id] in (SELECT node_id FROM GetDescendants(@nodeId, -1)) OR [node_id] = @nodeId
RETURN
