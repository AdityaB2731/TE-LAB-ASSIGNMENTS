include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <map>

using namespace std;

// Structure to hold MNT entry
struct MNTEntry {
    string name;
    int pp;
    int kp;
    int mdtp;
    int kpdtp;
};

// Function to read MNT from a file
map<string, MNTEntry> readMNT(const string& filename) {
    map<string, MNTEntry> mnt;
    ifstream file(filename);
    string line;
    getline(file, line); // Skip header
    while (getline(file, line)) {
        stringstream ss(line);
        MNTEntry entry;
        ss >> entry.name >> entry.pp >> entry.kp >> entry.mdtp >> entry.kpdtp;
        mnt[entry.name] = entry;
    }
    return mnt;
}

// Function to read MDT from a file
vector<string> readMDT(const string& filename) {
    vector<string> mdt;
    ifstream file(filename);
    string line, mdt_line;
    int index;
    while (getline(file, line)) {
        stringstream ss(line);
        ss >> index;
        getline(ss, mdt_line);
        // trim leading whitespace
        size_t first = mdt_line.find_first_not_of(" \t");
        if (string::npos != first) {
            mdt_line = mdt_line.substr(first);
        }
        mdt.push_back(mdt_line);
    }
    return mdt;
}

// Function to read KPDTAB from a file
vector<pair<string, string>> readKPDTAB(const string& filename) {
    vector<pair<string, string>> kpdtab;
    ifstream file(filename);
    string line;
    getline(file, line); // Skip header
    while (getline(file, line)) {
        stringstream ss(line);
        string param, def_val;
        ss >> param >> def_val;
        kpdtab.push_back({param, def_val});
    }
    return kpdtab;
}


int main() {
    // Read data structures from Pass 1
    map<string, MNTEntry> mnt = readMNT("mnt.txt");
    vector<string> mdt = readMDT("mdt.txt");
    vector<pair<string, string>> kpdtab = readKPDTAB("kpdtab.txt");
    
    ifstream intermediateFile("intermediate.txt");
    ofstream outputFile("output.txt");

    if (!intermediateFile.is_open() || !outputFile.is_open()) {
        cerr << "Error opening intermediate or output file." << endl;
        return 1;
    }

    string line;
    while (getline(intermediateFile, line)) {
        stringstream ss(line);
        string token;
        ss >> token;

        if (mnt.count(token)) {
            // It's a macro call, expand it
            MNTEntry entry = mnt[token];
            vector<string> aptab(entry.pp + entry.kp + 1);
            int aptab_ptr = 1;

            // Fill APTAB with positional parameters
            string param;
            while(ss >> param && aptab_ptr <= entry.pp){
                 if (!param.empty() && param.back() == ',') {
                    param.pop_back();
                }
                aptab[aptab_ptr++] = param;
            }

            // Handle keyword parameters and remaining positional
            map<string, string> keyword_params;
            do {
                 if (!param.empty() && param.back() == ',') {
                    param.pop_back();
                }
                size_t eq_pos = param.find('=');
                if(eq_pos != string::npos){
                    keyword_params[param.substr(0, eq_pos)] = param.substr(eq_pos + 1);
                }
            } while(ss >> param);


            // Fill APTAB with default/provided keyword parameters
            for(int i = 0; i < entry.kp; ++i){
                string param_name = kpdtab[entry.kpdtp - 1 + i].first;
                if(keyword_params.count(param_name)){
                    aptab[entry.pp + 1 + i] = keyword_params[param_name];
                } else {
                    aptab[entry.pp + 1 + i] = kpdtab[entry.kpdtp - 1 + i].second;
                }
            }

            // Expand the macro
            for (int i = entry.mdtp - 1; i < mdt.size(); ++i) {
                string mdt_line = mdt[i];
                if (mdt_line == "MEND") {
                    break;
                }
                
                stringstream mdt_ss(mdt_line);
                string mdt_token;
                string expanded_line;
                mdt_ss >> mdt_token;
                expanded_line += mdt_token;

                while(mdt_ss >> mdt_token){
                    if(mdt_token.substr(0,3) == "(P,"){
                        int p_index = stoi(mdt_token.substr(3, mdt_token.find(')') - 3));
                        expanded_line += " " + aptab[p_index];
                    } else {
                        expanded_line += " " + mdt_token;
                    }
                }
                outputFile << expanded_line << endl;
            }

        } else {
            // Not a macro call, just copy the line
            outputFile << line << endl;
        }
    }

    intermediateFile.close();
    outputFile.close();

    cout << "Pass 2 processing complete." << endl;
    cout << "Final expanded code is in output.txt" << endl;

    return 0;
}
