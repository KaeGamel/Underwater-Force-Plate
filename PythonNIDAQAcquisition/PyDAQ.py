import numpy as np
import nidaqmx
from nidaqmx import constants
from keyboard import is_pressed

DEVICE = "Dev2"
ANALOG_CHANNELS = [f"{DEVICE}/ai0",  # list of analog channels to listen to
                   f"{DEVICE}/ai1",
                   f"{DEVICE}/ai2",
                   f"{DEVICE}/ai3"]
CHUNK_DURATION = 1  # number of seconds each chunk should last
SAMPLE_RATE = 4000  # number of samples to be recorded per chunk
DURATION = 100  # overarching duration of recording, in seconds

# Calculate chunk size and number of chunks
chunk_size = SAMPLE_RATE * CHUNK_DURATION
total_chunks = DURATION // CHUNK_DURATION
print(f"Chunk size: {chunk_size} | Total chunks: {total_chunks}")

# Data acquisition and storing in memory
data_in_memory = {channel: [] for channel in ANALOG_CHANNELS}  # start with a set of empty lists
print(f"Please press SPACEBAR to begin reading from {DEVICE}...")
while True:
    if is_pressed('space'):  # if SPACEBAR is pressed...
        break  # break out of the loop

try:
    with nidaqmx.Task() as task:
        for channel in data_in_memory.keys():  # add voltage channels to active task
            task.ai_channels.add_ai_voltage_chan(channel, terminal_config=constants.TerminalConfiguration.RSE)

        task.timing.cfg_samp_clk_timing(rate=SAMPLE_RATE,  # configure sample rate and mode of active task
                                        sample_mode=constants.AcquisitionType.CONTINUOUS)

        # Read data in chunks and store in memory
        for _ in range(total_chunks):
            chunk_data = task.read(number_of_samples_per_channel=chunk_size)
            print(f"Reading chunk of length {len(chunk_data[0])}")
            for i, channel in enumerate(data_in_memory.keys()):
                data_in_memory[channel].append(chunk_data[i])  # fill each list in the set with data

        task.stop()
        print(f"\nFinished reading from {DEVICE}.")
finally:
    if task:
        task.close()
        print("Task complete.")

# Conversion of lists to numpy arrays for processing
for channel in data_in_memory:
    print(f"Pre-concatenation length for {channel}: {sum(len(chunk) for chunk in data_in_memory[channel])}")
    data_in_memory[channel] = np.concatenate(data_in_memory[channel])
    print(f"Post-concatenation length for {channel}: {len(data_in_memory[channel])}")

