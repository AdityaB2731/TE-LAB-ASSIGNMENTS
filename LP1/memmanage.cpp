#include <bits/stdc++.h>
using namespace std;
struct Block
{
    int size;
    bool free;
    int processId; // -1 if free
    Block(int s)
    {
        size = s;
        free = true;
        processId = -1;
    }
};
// Helper to print memory status
// void printMemory(const vector<Block>& memory) {
//     cout << "Memory Blocks: ";
//     for (int i = 0; i < memory.size(); i++) {
//         if (memory[i].free)
//             cout << "[Free:" << memory[i].size << "] ";
//         else
//             cout << "[P" << memory[i].processId << ":" << memory[i].size << "] ";
//     }
//     cout << "\n";
// }
void printMemory(const vector<Block> &memory)
{
    cout << left << setw(8) << "BlockID"
         << setw(12) << "Status"
         << setw(8) << "Size"
         << setw(10) << "Process" << "\n";
    cout << "--------------------------------------\n";
    for (int i = 0; i < memory.size(); i++)
    {
        cout << setw(8) << i + 1;
        if (memory[i].free)
        {
            cout << setw(12) << "Free"
                 << setw(8) << memory[i].size
                 << setw(10) << "-" << "\n";
        }
        else
        {
            cout << setw(12) << "Allocated"
                 << setw(8) << memory[i].size
                 << setw(10) << memory[i].processId << "\n";
        }
    }
    cout << "\n";
}
// First Fit Allocation
void firstFit(vector<Block> &memory, int processId, int processSize)
{
    for (int i = 0; i < memory.size(); i++)
    {
        if (memory[i].free && memory[i].size >= processSize)
        {
            int leftover = memory[i].size - processSize;
            memory[i].size = processSize;
            memory[i].free = false;
            memory[i].processId = processId;
            if (leftover > 0)
                memory.insert(memory.begin() + i + 1, Block(leftover));
            break;
        }
    }
}
// Best Fit Allocation
void bestFit(vector<Block> &memory, int processId, int processSize)
{
    int bestIdx = -1;
    int minSpace = INT_MAX;
    for (int i = 0; i < memory.size(); i++)
    {
        if (memory[i].free && memory[i].size >= processSize && (memory[i].size - processSize) < minSpace)
        {
            bestIdx = i;
            minSpace = memory[i].size - processSize;
        }
    }
    if (bestIdx != -1)
    {
        int leftover = memory[bestIdx].size - processSize;
        memory[bestIdx].size = processSize;
        memory[bestIdx].free = false;
        memory[bestIdx].processId = processId;
        if (leftover > 0)
            memory.insert(memory.begin() + bestIdx + 1, Block(leftover));
    }
}
// Worst Fit Allocation
void worstFit(vector<Block> &memory, int processId, int processSize)
{
    int worstIdx = -1;
    int maxSpace = -1;
    for (int i = 0; i < memory.size(); i++)
    {
        if (memory[i].free && memory[i].size >= processSize && (memory[i].size - processSize) > maxSpace)
        {
            worstIdx = i;
            maxSpace = memory[i].size - processSize;
        }
    }
    if (worstIdx != -1)
    {
        int leftover = memory[worstIdx].size - processSize;
        memory[worstIdx].size = processSize;
        memory[worstIdx].free = false;
        memory[worstIdx].processId = processId;
        if (leftover > 0)
            memory.insert(memory.begin() + worstIdx + 1, Block(leftover));
    }
}
// Next Fit Allocation
void nextFit(vector<Block> &memory, int processId, int processSize, int &lastIdx)
{
    int n = memory.size();
    int i = lastIdx;
    int count = 0;
    while (count < n)
    {
        if (memory[i].free && memory[i].size >= processSize)
        {
            int leftover = memory[i].size - processSize;
            memory[i].size = processSize;
            memory[i].free = false;
            memory[i].processId = processId;
            if (leftover > 0)
                memory.insert(memory.begin() + i + 1, Block(leftover));
            lastIdx = i;
            break;
        }
        i = (i + 1) % n;
        count++;
    }
}
int main()
{
    int nBlocks;
    cout << "Enter number of memory blocks: ";
    cin >> nBlocks;
    vector<Block> memory;
    cout << "Enter size of each memory block:\n";
    for (int i = 0; i < nBlocks; i++)
    {
        int size;
        cin >> size;
        memory.push_back(Block(size));
    }
    int nProcesses;
    cout << "Enter number of processes: ";
    cin >> nProcesses;
    vector<int> processSize(nProcesses);
    cout << "Enter size of each process:\n";
    for (int i = 0; i < nProcesses; i++)
    {
        cin >> processSize[i];
    }
    vector<Block> memFirst = memory;
    vector<Block> memBest = memory;
    vector<Block> memWorst = memory;
    vector<Block> memNext = memory;
    int lastIdx = 0; // for next fit
    cout << "\n--- First Fit Allocation ---\n";
    for (int i = 0; i < nProcesses; i++)
    {
        firstFit(memFirst, i + 1, processSize[i]);
    }
    printMemory(memFirst);
    cout << "\n--- Best Fit Allocation ---\n";
    for (int i = 0; i < nProcesses; i++)
    {
        bestFit(memBest, i + 1, processSize[i]);
    }
    printMemory(memBest);
    cout << "\n--- Worst Fit Allocation ---\n";
    for (int i = 0; i < nProcesses; i++)
    {
        worstFit(memWorst, i + 1, processSize[i]);
    }
    printMemory(memWorst);
    cout << "\n--- Next Fit Allocation ---\n";
    for (int i = 0; i < nProcesses; i++)
    {
        nextFit(memNext, i + 1, processSize[i], lastIdx);
    }
    printMemory(memNext);
    while (true)
    {
        char choice;
        cout << "\nDo you want to add more processes? (y/n): ";
        cin >> choice;
        if (choice != 'y' && choice != 'Y')
            break;
        int newProcesses;
        cout << "Enter number of new processes: ";
        cin >> newProcesses;
        vector<int> newProcessSize(newProcesses);
        cout << "Enter size of each new process:\n";
        for (int i = 0; i < newProcesses; i++)
        {
            cin >> newProcessSize[i];
        }
        // Allocate for all strategies
        cout << "\n--- First Fit Allocation ---\n";
        for (int i = 0; i < newProcesses; i++)
        {
            firstFit(memFirst, nProcesses + i + 1, newProcessSize[i]);
            printMemory(memFirst);
        }
        cout << "\n--- Best Fit Allocation ---\n";
        for (int i = 0; i < newProcesses; i++)
        {
            bestFit(memBest, nProcesses + i + 1, newProcessSize[i]);
            printMemory(memBest);
        }
        cout << "\n--- Worst Fit Allocation ---\n";
        for (int i = 0; i < newProcesses; i++)
        {
            worstFit(memWorst, nProcesses + i + 1, newProcessSize[i]);
            printMemory(memWorst);
        }
        cout << "\n--- Next Fit Allocation ---\n";
        for (int i = 0; i < newProcesses; i++)
        {
            nextFit(memNext, nProcesses + i + 1, newProcessSize[i], lastIdx);
            printMemory(memNext);
        }
        nProcesses += newProcesses; // update total process count
    }
    return 0;
}