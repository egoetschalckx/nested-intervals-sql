CREATE PROCEDURE InsertRandomNode(
	@newNodeId BIGINT OUTPUT
) 
AS
	SET NOCOUNT ON
	DECLARE @name NVARCHAR(64) = 'eric'
	DECLARE @internalNewNodeId BIGINT
	DECLARE @parentNodeId BIGINT

	-- random UTF-8 string as name
	SELECT @name = CAST(CRYPT_GEN_RANDOM(8) AS NVARCHAR(64))

	-- query for random parent
	SELECT TOP 1 @parentNodeId = [node_id] FROM [Node] ORDER BY NEWID()

	EXECUTE InsertNode @parentNodeId, @name, @internalNewNodeId OUTPUT

	SET @newNodeId = @internalNewNodeId
RETURN
