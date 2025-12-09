-- proposal basic functions

function create_proposal(contract_name, function_name, params, subject, end_time)
    return contract_helper:create_proposal(contract_name, function_name, params, subject, end_time)
end

function update_proposal_votes(proposal_ids, approve)
    contract_helper:update_proposal_votes(proposal_ids, approve)
end

function remove_proposals(proposal_ids)
    contract_helper:remove_proposals(proposal_ids)
end
