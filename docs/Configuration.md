
# A - Create a log sender simulator
The log will send a message every second.
The message will have an ID, the ID will be changed every request, the value will rotate with the following format IDXXXN where N from 00 to 10.
This will allow us to test a filtering rule that filter between t0 and t1 a message that contains the IDXXX05.

# B - Configure Graylog
### 1 - Create Inputs
- Why : Interface to collect logs by HTTPs in a JSON format
- How : 
    - Parameters
        -  Endpoint =  http://graylog-host:12202/gelf

### 2 - Create Stream 
- Why : Route incoming messages to a single place to process them
- How : 
    1. Create the stream
        1. Go to Streams from the Graylog web interface.
        2. Click Create Stream.
        3. Give it a meaningful name (e.g., "Filtered Logs Stream").
        4. Optionally, add a description.
        5. Define rules for the stream—e.g., messages containing a field _id with value "IDXXX05".
        6. Save the stream.
        7. Enable the stream to start routing messages matching its rules.
    2. Associate the stream with the previous input [[????]]
        This routes matching messages arriving via that input into the stream.
        1. Go to System → Inputs.
        2. Select an existing input (e.g., GELF HTTP input) or create a new one listening on a particular port.
        3. Edit the input settings to add the previously created stream to the list of streams this input feeds.
        
### 3 - Create Pipeline Rules
- Why : Define how to filter messages
- How : 
    Pipelines allow complex processing and filtering.
    1. Go to System → Pipelines → Manage Rules.
    2. Click Create Rule.
    3. Use the Rule Builder or Source Editor.

    Example rule source filtering messages with _id == "IDXXX05":
    ```
    rule "filter_idxxx05"
    when
    to_string($message._id) == "IDXXX05"
    then
    // For example, send to a specific stream, add fields, or drop messages
    route_to_stream("Filtered Logs Stream"); // assuming stream name
    end
    ```
### 4 - Create and Associate a Pipeline
- How : 
    Pipelines allow complex processing and filtering.
    1. Go to System → Pipelines → Manage Pipelines.
    2. Create a new pipeline, give it a name (e.g., "Filter Pipeline").
    3. Add a stage (default is 0).
    4. Attach your created rule(s) to this stage.
    5. Save the pipeline.

### 5 - Connect Pipeline to Stream (or Global Pipeline)
- How : 
    1. Go to System → Pipelines → Connections.
    2. Connect the pipeline to the stream you want it to process.
    3. Alternatively, connect the pipeline globally to process all messages.

### 6 - View Filtered Messages
- How : 
    1. Go to Streams.
    2. Open the stream you created ("Filtered Logs Stream").
    3. You will see messages matching your filter (e.g., those with _id == IDXXX05).
    4. Use frequent queries and filters to inspect messages.

### 7 - Call the API to update the existing rule, add a new one and delete it

    The rules are sequentials so how to define the order? 

# Create Outputs

# Configure data persistence 