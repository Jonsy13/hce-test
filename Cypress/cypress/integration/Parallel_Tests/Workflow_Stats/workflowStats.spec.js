/// <reference types="Cypress" />
import * as user from "../../../fixtures/Users.json";
import routes from "../../../fixtures/routes";

export const agent = Cypress.env("AGENT");

describe("Testing the accessibility of workflow statistics Tab.", () => {
  before("Clearing the Cookies and deleting the Cookies", () => {
    cy.requestLogin(user.AdminName, user.AdminPassword);
    cy.waitForCluster(agent);
    cy.visit(routes.analytics());
  });

  it("Testing workflow stats tab", () => {
    cy.get("[data-cy=litmusDashboard]").should("be.visible");
    cy.get("[data-cy=litmusDashboard]").click();
  });
});
