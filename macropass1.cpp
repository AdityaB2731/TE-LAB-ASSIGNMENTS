#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <map>

using namespace std;

// Structure to hold MNT entry
struct MNTEntry {
    string name;
    int pp; // Number of positional parameters
    int kp; // Number of keyword parameters
    int mdtp; // MDT pointer
    int kpdtp; // KPDTAB pointer
};

// Function to write a vector of strings to a file
void writeToFile(const string& filename, const vector<string>& data) {
    ofstream file(filename);
    for (const auto& line : data) {
        file << line << endl;
    }
    file.close();
}

// Function to write MNT to a file
void writeMNTToFile(const string& filename, const map<string, MNTEntry>& mnt) {
    ofstream file(filename);
    file << "MacroName\t#PP\t#KP\tMDTP\tKPDTP\n";
    for (const auto& pair : mnt) {
        const auto& entry = pair.second;
        file << entry.name << "\t\t" << entry.pp << "\t" << entry.kp << "\t" << entry.mdtp << "\t" << entry.kpdtp << endl;
    }
    file.close();
}


int main() {
    ifstream inputFile("ipt.txt");
    if (!inputFile.is_open()) {
        cerr << "Error opening input file." << endl;
        return 1;
    }

    // Data structures
    map<string, MNTEntry> mnt;
    vector<string> mdt;
    map<string, int> pntab;
    vector<pair<string, string>> kpdtab;
    vector<string> intermediate_code;

    string line;
    bool macro_definition_mode = false;
    int mdt_ptr = 1;
    int pntab_ptr = 1;
    int kpdtab_ptr = 1;
    MNTEntry current_mnt_entry;

    while (getline(inputFile, line)) {
        stringstream ss(line);
        string token;
        ss >> token;

        if (token == "MACRO") {
            macro_definition_mode = true;
        
            // Read the next line for macro name and parameters
            if (!getline(inputFile, line)) {
                cerr << "Error: Expected macro header after MACRO" << endl;
                return 1;
            }
            stringstream ss_macro(line);
            ss_macro >> current_mnt_entry.name;
            current_mnt_entry.pp = 0;
            current_mnt_entry.kp = 0;
            current_mnt_entry.mdtp = mdt_ptr;
            current_mnt_entry.kpdtp = kpdtab_ptr;
            pntab.clear();
        
            string param;
            while (ss_macro >> param) {
                if (param[0] == '&') param.erase(0, 1);
                if (!param.empty() && param.back() == ',') param.pop_back();
        
                size_t eq_pos = param.find('=');
                if (eq_pos != string::npos) {
                    current_mnt_entry.kp++;
                    string param_name = param.substr(0, eq_pos);
                    string default_value = param.substr(eq_pos + 1);
                    pntab[param_name] = pntab_ptr++;
                    kpdtab.push_back({param_name, default_value});
                } else {
                    current_mnt_entry.pp++;
                    pntab[param] = pntab_ptr++;
                }
            }
        }
        
        else if (token == "MEND") {
            macro_definition_mode = false;
            mdt.push_back("MEND");
            mdt_ptr++;
            mnt[current_mnt_entry.name] = current_mnt_entry;
            kpdtab_ptr += current_mnt_entry.kp;
            pntab_ptr = 1; // Reset for next macro
        } else if (macro_definition_mode) {
            stringstream line_ss(line);
            string opcode;
            line_ss >> opcode;
            string expanded_line = opcode;
            string operand;
            
            while(line_ss >> operand){
                if (operand[0] == '&') {
                    operand.erase(0, 1);
                     if (!operand.empty() && operand.back() == ',') {
                        operand.pop_back();
                    }
                    if (pntab.count(operand)) {
                        expanded_line += " (P," + to_string(pntab[operand]) + ")";
                    } else {
                         expanded_line += " &" + operand;
                    }
                } else {
                    expanded_line += " " + operand;
                }
            }
            mdt.push_back(expanded_line);
            mdt_ptr++;
        } else {
            intermediate_code.push_back(line);
        }
    }

    inputFile.close();

    // --- Outputting the results ---
    cout << "Pass 1 processing complete." << endl;
    cout << "Check the generated files." << endl;

    // MNT
    writeMNTToFile("mnt.txt", mnt);

    // MDT
    ofstream mdt_file("mdt.txt");
    int i = 1;
    for(const auto& mdt_line : mdt){
        mdt_file << i++ << "\t" << mdt_line << endl;
    }
    mdt_file.close();


    // PNTAB for the last macro for verification
    ofstream pntab_file("pntab.txt");
    pntab_file << "Parameter\tIndex\n";
    for(const auto& pair : pntab){
        pntab_file << pair.first << "\t\t" << pair.second << endl;
    }
    pntab_file.close();
    
    // KPDTAB
    ofstream kpdtab_file("kpdtab.txt");
    kpdtab_file << "Parameter\tDefault\n";
    for(const auto& pair : kpdtab){
        kpdtab_file << pair.first << "\t\t" << pair.second << endl;
    }
    kpdtab_file.close();

    // Intermediate Code
    writeToFile("intermediate.txt", intermediate_code);

    return 0;
}

