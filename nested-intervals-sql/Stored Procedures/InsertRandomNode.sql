CREATE PROCEDURE InsertRandomNode(
	@newNodeId BIGINT OUTPUT
) 
AS
	SET NOCOUNT ON
	DECLARE @name NVARCHAR(64) = 'eric'
	DECLARE @internalNewNodeId BIGINT
	DECLARE @parentNodeId BIGINT

	SELECT @name = cast(crypt_gen_random(8) AS NVARCHAR(64))

	SELECT TOP 1 @parentNodeId = node_id FROM [Node] ORDER BY NEWID()

	EXECUTE InsertNode @parentNodeId, @name, @internalNewNodeId OUTPUT

	SET @newNodeId = @internalNewNodeId
RETURN
