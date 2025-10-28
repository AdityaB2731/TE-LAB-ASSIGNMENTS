
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cctype>
using namespace std;

struct MNTEntry {
    string name;
    int pp;    // positional params
    int kp;    // keyword params
    int mdtp;  // 1-based
    int kpdtp; // 1-based
};

struct KPDTABEntry {
    string key;
    string defaultVal;
};

vector<MNTEntry> MNT;
vector<string> MDT;
vector<KPDTABEntry> KPDTAB;

// trim whitespace both ends
string trim(const string &s) {
    int i = 0, j = (int)s.size() - 1;
    while (i <= j && (s[i] == ' ' || s[i] == '\t')) ++i;
    while (j >= i && (s[j] == ' ' || s[j] == '\t')) --j;
    if (i > j) return "";
    return s.substr(i, j - i + 1);
}

// split by commas
vector<string> split_commas(const string &s) {
    vector<string> out;
    string cur;
    for (char c : s) {
        if (c == ',') { out.push_back(trim(cur)); cur.clear(); }
        else cur.push_back(c);
    }
    if (!cur.empty()) out.push_back(trim(cur));
    return out;
}

// split by whitespace
vector<string> split_ws(const string &s) {
    vector<string> t;
    string cur;
    for (char c: s) {
        if (isspace((unsigned char)c)) { if (!cur.empty()) { t.push_back(cur); cur.clear(); } }
        else cur.push_back(c);
    }
    if (!cur.empty()) t.push_back(cur);
    return t;
}

void loadTables() {
    // MNT.txt
    ifstream mntf("MNT.txt");
    if (mntf.is_open()) {
        string line; getline(mntf, line);
        while (getline(mntf, line)) {
            line = trim(line);
            if (line.empty()) continue;
            auto toks = split_ws(line);
            if (toks.size() < 6) continue;
            if (!isdigit(toks[0][0])) continue;
            MNTEntry e;
            e.name = toks[1]; e.pp = stoi(toks[2]); e.kp = stoi(toks[3]);
            e.mdtp = stoi(toks[4]); e.kpdtp = stoi(toks[5]);
            MNT.push_back(e);
        }
        mntf.close();
    }

    // KPDTAB.txt
    ifstream kpf("KPDTAB.txt");
    if (kpf.is_open()) {
        string line; getline(kpf, line);
        while (getline(kpf, line)) {
            line = trim(line);
            if (line.empty()) continue;
            auto toks = split_ws(line);
            if (toks.size() < 3) continue;
            if (!isdigit(toks[0][0])) continue;
            KPDTABEntry e;
            e.key = toks[1]; if (!e.key.empty() && e.key[0]=='&') e.key = e.key.substr(1);
            e.defaultVal = toks[2];
            KPDTAB.push_back(e);
        }
        kpf.close();
    }

    // MDT.txt
    ifstream mdtf("MDT.txt");
    if (mdtf.is_open()) {
        string line; getline(mdtf, line);
        while (getline(mdtf, line)) {
            line = trim(line);
            if (line.empty()) continue;
            auto toks = split_ws(line);
            if (toks.size() < 2) continue;
            MDT.push_back(line.substr(line.find(toks[1])));
        }
        mdtf.close();
    }
}

bool isMacroCall(const string &line, MNTEntry &out) {
    for (auto &m : MNT) {
        if (line.rfind(m.name, 0) == 0) {
            if (line.size() == m.name.size() || isspace((unsigned char)line[m.name.size()])) {
                out = m; return true;
            }
        }
    }
    return false;
}

// Build ALA for this macro call
vector<string> buildALA(const MNTEntry &m, const string &currLine) {
    vector<string> ALA(m.pp + m.kp, "");

    size_t pos = currLine.find(' ');
    string paramStr = (pos == string::npos) ? "" : trim(currLine.substr(pos + 1));
    auto toks = split_commas(paramStr);

    int idx = 0;

    // Fill positional params
    for (int p = 0; p < m.pp && idx < (int)toks.size(); ++p) {
        if (toks[idx].find('=') == string::npos) { ALA[p] = toks[idx]; ++idx; }
        else { ++idx; --p; } // skip keyword
    }

    // Fill defaults for KP
    for (int k=0; k<m.kp; ++k) {
        int kpIndex = (m.kpdtp - 1) + k;
        if (kpIndex >=0 && kpIndex < (int)KPDTAB.size())
            ALA[m.pp + k] = KPDTAB[kpIndex].defaultVal;
    }

    // Remaining positional tokens override KP in order
    for (; idx < (int)toks.size(); ++idx) {
        string tok = toks[idx];
        size_t eq = tok.find('=');
        if (eq == string::npos) {
            // assign to next keyword param
            for (int k=0; k<m.kp; ++k) {
                if (ALA[m.pp+k] == KPDTAB[(m.kpdtp-1)+k].defaultVal) {
                    ALA[m.pp+k] = tok;
                    break;
                }
            }
        } else {
            // key=value form
            string key = trim(tok.substr(0,eq));
            string val = trim(tok.substr(eq+1));
            if (!key.empty() && key[0]=='&') key = key.substr(1);
            for (int k=0; k<m.kp; ++k) {
                int kpIndex = (m.kpdtp-1)+k;
                if (kpIndex>=0 && kpIndex<(int)KPDTAB.size() && KPDTAB[kpIndex].key==key)
                    ALA[m.pp+k]=val;
            }
        }
    }

    return ALA;
}

// Expand macro
void expandMacro(const MNTEntry &m, const vector<string> &ALA, ofstream &out) {
    int idx = m.mdtp-1;
    while (idx < (int)MDT.size()) {
        string ln = MDT[idx];
        if (ln=="MEND") break;

        string expanded;
        for (size_t i=0;i<ln.size();++i){
            if (ln[i]=='(' && i+2<ln.size() && ln[i+1]=='P' && ln[i+2]==','){
                int j=i+3; int num=0;
                while (j<ln.size() && isdigit(ln[j])){ num=num*10+(ln[j]-'0'); ++j; }
                if (j<ln.size() && ln[j]==')'){ if (num>=1 && num<=(int)ALA.size()) expanded+=ALA[num-1]; i=j; continue; }
            }
            expanded+=ln[i];
        }
        out << "+ " << expanded << "\n";
        ++idx;
    }
}

int main() {
    loadTables();

    ifstream src("file.txt");
    if (!src.is_open()){ cerr<<"Error: file.txt not found\n"; return 1; }

    ofstream out("expanded_code.txt");
    if (!out.is_open()){ cerr<<"Error: cannot create expanded_code.txt\n"; return 1; }

    ofstream alaFile("ALA.txt"); // clear old file
    alaFile.close();

    string line; bool skip=false;
    while (getline(src,line)){
        line=trim(line);
        if (line.empty()) continue;

        if (line=="MACRO"){ skip=true; continue; }
        if (line=="MEND" && skip){ skip=false; continue; }
        if (skip) continue;

        MNTEntry m;
        if (isMacroCall(line,m)){
            vector<string> ALA = buildALA(m,line);

            // save ALA for this call
            ofstream alaFile("ALA.txt", ios::app);
            alaFile << m.name << ":\n";
            for (size_t i=0;i<ALA.size();++i) alaFile << i+1 << " ---> " << ALA[i] << "\n";
            alaFile << "\n";
            alaFile.close();

            expandMacro(m,ALA,out);
        } else {
            out << line << endl;
        }
    }

    return 0;
}
