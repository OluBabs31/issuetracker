import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type IssueId = Nat;
  
  type Issue = {
    id: IssueId;
    title: Text;
    description: Text;
    status: Text;  // "open", "in-progress", "closed"
    createdAt: Time.Time;
  };

  var issues = Buffer.Buffer<Issue>(0);

  public func createIssue(title: Text, description: Text) : async IssueId {
    let issueId = issues.size();
    let newIssue: Issue = {
      id = issueId;
      title = title;
      description = description;
      status = "open";
      createdAt = Time.now();
    };
    issues.add(newIssue);
    issueId
  };

  public query func getIssue(issueId: IssueId) : async ?Issue {
    if (issueId < issues.size()) {
      ?issues.get(issueId)
    } else {
      null
    };
  };

  public func updateIssueStatus(issueId: IssueId, newStatus: Text) : async Bool {
    if (issueId >= issues.size()) return false;
    let issue = issues.get(issueId);
    
    let updatedIssue: Issue = {
      id = issue.id;
      title = issue.title;
      description = issue.description;
      status = newStatus;
      createdAt = issue.createdAt;
    };
    issues.put(issueId, updatedIssue);
    true
  };

  public query func getAllIssues() : async [Issue] {
    Buffer.toArray(issues)
  };
};