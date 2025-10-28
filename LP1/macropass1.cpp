#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <fstream>

using namespace std;

// structure for MNT entries
struct MNTEntry {
    string name;
    int pp;    
    int kp;    
    int mdtp;  
    int kpdtp; 
};

// Global tables
vector<MNTEntry> MNT;                     
vector<pair<string, string>> KPDTAB;      
vector<string> MDT;                       
map<string, map<string, int>> PNTAB_per_macro; 

int mdtp = 1;  // MDT pointer
int kpdtp = 1; // KPDTAB pointer

// Trim whitespace from a string
string trim(const string& s) {
    int start = 0, end = s.length() - 1;
    while (start < s.length() && (s[start] == ' ' || s[start] == '\t')) start++;
    while (end >= 0 && (s[end] == ' ' || s[end] == '\t')) end--;
    if (start > end) return "";
    return s.substr(start, end - start + 1);
}

// Split a string by comma
vector<string> split(const string& s) {
    vector<string> result;
    string current = "";
    for (char c : s) {
        if (c == ',') {
            result.push_back(trim(current));
            current = "";
        } else {
            current += c;
        }
    }
    if (!current.empty()) result.push_back(trim(current));
    return result;
}

// Process macro header to extract parameters
void process_macro_header(const string& line, string& macro_name, int& pp, int& kp,
    map<string, int>& pntab, vector<pair<string, string>>& kpdt_entries) {
    // Extract macro name and parameters
    int space_pos = line.find(' ');
    macro_name = line.substr(0, space_pos);
    string params_str = trim(line.substr(space_pos));

    // Split parameters
    vector<string> params = split(params_str);

    pp = 0;
    kp = 0;
    int position = 1;

    for (string param : params) {
        if (param.empty()) continue;
        // Check if parameter is keyword (contains '=')
        int eq_pos = param.find('=');
        if (eq_pos != string::npos) {
            kp++;
            string pname = param.substr(1, eq_pos - 1); // Skip '&'
            string default_val = param.substr(eq_pos + 1);
            if (default_val.empty()) default_val = "--------";
            pntab[pname] = position;
            kpdt_entries.push_back({pname, default_val});
        } else {
            pp++;
            string pname = param.substr(1); // Skip '&'
            pntab[pname] = position;
        }
        position++;
    }
}

// Replace parameters in macro body with PNTAB indices
string replace_params(const string& line, const map<string, int>& pntab) {
    string result = "";
    string word = "";
    bool in_param = false;

    for (int i = 0; i < line.length(); i++) {
        char c = line[i];
        if (c == '&') {
            in_param = true;
            word = "";
            continue;
        }
        if (in_param && (c == ' ' || c == ',' || i == line.length() - 1)) {
            if (i == line.length() - 1 && c != ' ' && c != ',') word += c;
            if (pntab.find(word) != pntab.end()) {
                result += "(P," + to_string(pntab.at(word)) + ")";
            } else {
                result += "&" + word;
            }
            in_param = false;
            if (c == ' ' || c == ',') result += c;
        } else if (in_param) {
            word += c;
        } else {
            result += c;
        }
    }

    return result;
}

int main() {
    vector<string> lines;
    ifstream infile("file.txt");
    if (!infile.is_open()) {
        cerr << "Error: Could not open file.txt\n";
        return 1;
    }
    string temp;
    while (getline(infile, temp)) {
        if (!temp.empty()) lines.push_back(trim(temp));
    }
    infile.close();

    int i = 0;
    while (i < lines.size()) {
        string line = trim(lines[i]);
        if (line == "MACRO") {
            i++;
            string header_line = trim(lines[i]);
            string macro_name;
            int pp = 0, kp = 0;
            map<string, int> pntab;
            vector<pair<string, string>> kpdt_entries;

            process_macro_header(header_line, macro_name, pp, kp, pntab, kpdt_entries);

            // Update KPDTAB
            int current_kpdtp = kpdtp;
            for (auto& entry : kpdt_entries) {
                KPDTAB.push_back(entry);
                kpdtp++;
            }

            // Update MNT and store PNTAB
            int current_mdtp = mdtp;
            MNT.push_back({macro_name, pp, kp, current_mdtp, current_kpdtp});
            PNTAB_per_macro[macro_name] = pntab;

            // Process macro body
            i++;
            while (i < lines.size()) {
                string body_line = trim(lines[i]);
                if (body_line == "MEND") {
                    MDT.push_back("MEND");
                    mdtp++;
                    break;
                }
                string replaced_line = replace_params(body_line, pntab);
                MDT.push_back(replaced_line);
                mdtp++;
                i++;
            }
        }
        i++;
    }

    //MNT
    cout << "MNT\nIndex\tName\t#PP\t#KP\tMDTP\tKPDTP\n";
    ofstream mntFile("MNT.txt");
    mntFile << "MNT\nIndex\tName\t#PP\t#KP\tMDTP\tKPDTP\n";
    for (int idx = 0; idx < MNT.size(); idx++) {
        auto& e = MNT[idx];
        cout << idx + 1 << "\t" << e.name << "\t" << e.pp << "\t" << e.kp << "\t" << e.mdtp << "\t" << e.kpdtp << "\n";
        mntFile << idx + 1 << "\t" << e.name << "\t" << e.pp << "\t" << e.kp << "\t" << e.mdtp << "\t" << e.kpdtp << "\n";
    }
    mntFile.close();

    //KPDTAB
    cout << "\nKPDTAB\nIndex\tParam\tDefault\n";
    ofstream kpdtFile("KPDTAB.txt");
    kpdtFile << "KPDTAB\nIndex\tParam\tDefault\n";
    for (int idx = 0; idx < KPDTAB.size(); idx++) {
        cout << idx + 1 << "\t" << KPDTAB[idx].first << "\t" << KPDTAB[idx].second << "\n";
        kpdtFile << idx + 1 << "\t" << KPDTAB[idx].first << "\t" << KPDTAB[idx].second << "\n";
    }
    kpdtFile.close();

    //MDT
    cout << "\nMDT\n";
    ofstream mdtFile("MDT.txt");
    mdtFile << "MDT\n";
    for (int idx = 0; idx < MDT.size(); idx++) {
        cout << idx + 1 << "\t" << MDT[idx] << "\n";
        mdtFile << idx + 1 << "\t" << MDT[idx] << "\n";
    }
    mdtFile.close();

    //PNTAB
    cout << "\nPNTAB per Macro\n";
    ofstream pntabFile("PNTAB.txt");
    pntabFile << "PNTAB per Macro\n";
    for (auto& macro : MNT) {
        cout << macro.name << ":\n";
        pntabFile << macro.name << ":\n";
        auto& pntab = PNTAB_per_macro[macro.name];
        for (auto& p : pntab) {
            cout << p.second << " ---> " << p.first << "\n";
            pntabFile << p.second << " ---> " << p.first << "\n";
        }
        cout << "\n";
        pntabFile << "\n";
    }
    pntabFile.close();

    return 0;
}
